import { basename, dirname, resolve, relative } from 'node:path';
import type { ScanResult, ExtractionResult, FilemapData } from './types.js';

export function aggregateDirectory(
  scan: ScanResult,
  extractions: Map<string, ExtractionResult>,
  projectRoot: string
): FilemapData {
  const files: Record<string, string[]> = {};
  const allImports = new Set<string>();

  for (const file of scan.files) {
    const extraction = extractions.get(file.name);
    if (extraction) {
      files[file.name] = extraction.exports;

      for (const imp of extraction.imports) {
        const resolvedImport = resolveImport(imp, scan.path, projectRoot);
        if (resolvedImport && !isInternalImport(resolvedImport, scan.path, projectRoot)) {
          allImports.add(resolvedImport);
        }
      }
    }
  }

  return {
    v: 1,
    m: basename(scan.path),
    p: '[Purpose TBD]',
    _: new Date().toISOString(),
    f: files,
    i: [...allImports].sort(),
    d: scan.subdirs,
  };
}

function resolveImport(
  importPath: string,
  currentDir: string,
  projectRoot: string
): string | null {
  if (importPath.startsWith('.')) {
    const absolutePath = resolve(currentDir, importPath);
    const relativePath = relative(projectRoot, absolutePath);
    if (relativePath.startsWith('..')) {
      return null;
    }
    return relativePath.replace(/\\/g, '/');
  }

  if (importPath.startsWith('@/') || importPath.startsWith('~/')) {
    return importPath.slice(2);
  }

  return importPath;
}

function isInternalImport(
  resolvedImport: string,
  currentDir: string,
  projectRoot: string
): boolean {
  if (!resolvedImport.startsWith('.') && !resolvedImport.includes('/')) {
    return false;
  }

  const currentRelative = relative(projectRoot, currentDir).replace(/\\/g, '/');

  if (resolvedImport.startsWith(currentRelative + '/')) {
    const remainder = resolvedImport.slice(currentRelative.length + 1);
    return !remainder.includes('/');
  }

  return false;
}
