#!/usr/bin/env node

import { Command } from 'commander';
import { resolve } from 'node:path';
import { loadConfig } from './config.js';
import { scanDirectory, walkDirectories } from './scanner.js';
import { extractFile } from './extractor.js';
import { aggregateDirectory } from './aggregator.js';
import { writeFilemap, formatResult } from './writer.js';
import type { CLIOptions, ExtractionResult } from './types.js';

const program = new Command();

program
  .name('filemap-gen')
  .description('Generate .filemap.json files for codebase navigation')
  .version('1.0.0')
  .argument('[path]', 'Target directory', '.')
  .option('-r, --recursive', 'Scan subdirectories', true)
  .option('--no-recursive', 'Do not scan subdirectories')
  .option('-d, --depth <number>', 'Maximum recursion depth', parseInt)
  .option('--dry-run', 'Preview without writing files', false)
  .option('--force', 'Overwrite existing filemaps', false)
  .option('-q, --quiet', 'Suppress output', false)
  .option('-v, --verbose', 'Detailed output', false)
  .action(async (targetPath: string, opts) => {
    const options: CLIOptions = {
      recursive: opts.recursive,
      depth: opts.depth,
      dryRun: opts.dryRun,
      force: opts.force,
      quiet: opts.quiet,
      verbose: opts.verbose,
    };

    const projectRoot = resolve(targetPath);
    const config = loadConfig(projectRoot);

    if (!options.quiet) {
      console.log(`Generating filemaps for: ${projectRoot}`);
      if (options.dryRun) {
        console.log('(dry run - no files will be written)\n');
      } else {
        console.log('');
      }
    }

    let totalDirs = 0;
    let totalFiles = 0;
    let totalExports = 0;

    if (options.recursive) {
      for (const scan of walkDirectories(projectRoot, config, options.depth)) {
        const result = processDirectory(scan.path, projectRoot, config, options);
        if (result) {
          totalDirs++;
          totalFiles += Object.keys(result.data.f).length;
          totalExports += Object.values(result.data.f).reduce((sum, e) => sum + e.length, 0);
          const output = formatResult(scan.path, result.data, result.writeResult, options);
          if (output) console.log(output);
        }
      }
    } else {
      const scan = scanDirectory(projectRoot, config);
      const result = processDirectory(scan.path, projectRoot, config, options);
      if (result) {
        totalDirs++;
        totalFiles += Object.keys(result.data.f).length;
        totalExports += Object.values(result.data.f).reduce((sum, e) => sum + e.length, 0);
        const output = formatResult(scan.path, result.data, result.writeResult, options);
        if (output) console.log(output);
      }
    }

    if (!options.quiet) {
      console.log(`\nDone: ${totalDirs} directories, ${totalFiles} files, ${totalExports} exports`);
    }
  });

function processDirectory(
  dirPath: string,
  projectRoot: string,
  config: ReturnType<typeof loadConfig>,
  options: CLIOptions
) {
  const scan = scanDirectory(dirPath, config);

  if (scan.files.length === 0 && scan.subdirs.length === 0) {
    return null;
  }

  const extractions = new Map<string, ExtractionResult>();

  for (const file of scan.files) {
    const extraction = extractFile(file.path);
    extractions.set(file.name, extraction);
  }

  const data = aggregateDirectory(scan, extractions, projectRoot);
  const writeResult = writeFilemap(dirPath, data, options);

  return { data, writeResult };
}

program.parse();
