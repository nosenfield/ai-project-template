import { readFileSync, existsSync } from 'node:fs';
import { join } from 'node:path';
import type { Config } from './types.js';

const DEFAULT_CONFIG: Config = {
  exclude: {
    directories: [
      'node_modules',
      'dist',
      'build',
      '.git',
      '.next',
      'coverage',
      '__pycache__',
      '.turbo',
      '.vercel',
    ],
    files: [
      '*.test.*',
      '*.spec.*',
      '*.d.ts',
      '*.config.*',
      '*.min.*',
    ],
  },
  include: {
    extensions: ['.ts', '.tsx', '.js', '.jsx', '.mjs'],
  },
};

export function loadConfig(projectRoot: string): Config {
  const configPath = join(projectRoot, '.filemaprc.json');

  if (!existsSync(configPath)) {
    return DEFAULT_CONFIG;
  }

  try {
    const fileContent = readFileSync(configPath, 'utf-8');
    const userConfig = JSON.parse(fileContent) as Partial<Config>;
    return mergeConfig(DEFAULT_CONFIG, userConfig);
  } catch {
    console.warn(`Warning: Could not parse .filemaprc.json, using defaults`);
    return DEFAULT_CONFIG;
  }
}

function mergeConfig(base: Config, override: Partial<Config>): Config {
  return {
    exclude: {
      directories: override.exclude?.directories ?? base.exclude.directories,
      files: override.exclude?.files ?? base.exclude.files,
    },
    include: {
      extensions: override.include?.extensions ?? base.include.extensions,
    },
  };
}

export function shouldExcludeDirectory(name: string, config: Config): boolean {
  return config.exclude.directories.includes(name);
}

export function shouldIncludeFile(name: string, config: Config): boolean {
  const ext = getExtension(name);
  if (!config.include.extensions.includes(ext)) {
    return false;
  }

  for (const pattern of config.exclude.files) {
    if (matchesPattern(name, pattern)) {
      return false;
    }
  }

  return true;
}

function getExtension(filename: string): string {
  const lastDot = filename.lastIndexOf('.');
  return lastDot === -1 ? '' : filename.slice(lastDot);
}

function matchesPattern(filename: string, pattern: string): boolean {
  const regex = pattern
    .replace(/\./g, '\\.')
    .replace(/\*/g, '.*');
  return new RegExp(`^${regex}$`).test(filename);
}
