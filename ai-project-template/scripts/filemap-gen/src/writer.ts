import { writeFileSync, readFileSync, existsSync } from 'node:fs';
import { join } from 'node:path';
import type { FilemapData, WriteResult, CLIOptions } from './types.js';

export function writeFilemap(
  dirPath: string,
  data: FilemapData,
  options: CLIOptions
): WriteResult {
  const targetPath = join(dirPath, '.filemap.json');

  if (options.dryRun) {
    return 'DRY_RUN';
  }

  if (existsSync(targetPath) && !options.force) {
    try {
      const existing = JSON.parse(readFileSync(targetPath, 'utf-8')) as FilemapData;
      if (existing.p && existing.p !== '[Purpose TBD]') {
        data.p = existing.p;
      }
    } catch {
      // Ignore parse errors, overwrite with new data
    }
  }

  const content = JSON.stringify(data, null, 2) + '\n';
  writeFileSync(targetPath, content, 'utf-8');

  return 'WRITTEN';
}

export function formatResult(
  dirPath: string,
  data: FilemapData,
  result: WriteResult,
  options: CLIOptions
): string {
  if (options.quiet) {
    return '';
  }

  const fileCount = Object.keys(data.f).length;
  const exportCount = Object.values(data.f).reduce((sum, exports) => sum + exports.length, 0);
  const importCount = data.i.length;
  const subdirCount = data.d.length;

  const prefix = result === 'DRY_RUN' ? '[dry-run] ' : '';
  const status = result === 'WRITTEN' ? 'wrote' : result === 'SKIPPED' ? 'skipped' : 'would write';

  let output = `${prefix}${status}: ${dirPath}/.filemap.json`;

  if (options.verbose) {
    output += `\n  files: ${fileCount}, exports: ${exportCount}, imports: ${importCount}, subdirs: ${subdirCount}`;
  }

  return output;
}
