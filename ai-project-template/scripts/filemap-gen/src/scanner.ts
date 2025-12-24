import { readdirSync, statSync } from 'node:fs';
import { join, extname } from 'node:path';
import type { Config, ScanResult, FileInfo } from './types.js';
import { shouldExcludeDirectory, shouldIncludeFile } from './config.js';

export function scanDirectory(dirPath: string, config: Config): ScanResult {
  const files: FileInfo[] = [];
  const subdirs: string[] = [];

  let entries: string[];
  try {
    entries = readdirSync(dirPath);
  } catch {
    return { path: dirPath, files: [], subdirs: [] };
  }

  for (const entry of entries) {
    const fullPath = join(dirPath, entry);

    let stat;
    try {
      stat = statSync(fullPath);
    } catch {
      continue;
    }

    if (stat.isDirectory()) {
      if (!shouldExcludeDirectory(entry, config)) {
        subdirs.push(entry);
      }
    } else if (stat.isFile()) {
      if (shouldIncludeFile(entry, config)) {
        files.push({
          name: entry,
          path: fullPath,
          extension: extname(entry),
        });
      }
    }
  }

  return {
    path: dirPath,
    files: files.sort((a, b) => a.name.localeCompare(b.name)),
    subdirs: subdirs.sort(),
  };
}

export function* walkDirectories(
  rootPath: string,
  config: Config,
  maxDepth?: number
): Generator<ScanResult> {
  const queue: Array<{ path: string; depth: number }> = [
    { path: rootPath, depth: 0 },
  ];

  while (queue.length > 0) {
    const current = queue.shift()!;

    if (maxDepth !== undefined && current.depth > maxDepth) {
      continue;
    }

    const scan = scanDirectory(current.path, config);
    yield scan;

    for (const subdir of scan.subdirs) {
      queue.push({
        path: join(current.path, subdir),
        depth: current.depth + 1,
      });
    }
  }
}
