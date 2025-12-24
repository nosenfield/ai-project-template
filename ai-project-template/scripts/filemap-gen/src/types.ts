export interface FilemapData {
  v: 1;
  m: string;
  p: string;
  _: string;
  f: Record<string, string[]>;
  i: string[];
  d: string[];
}

export interface FileInfo {
  name: string;
  path: string;
  extension: string;
}

export interface ScanResult {
  path: string;
  files: FileInfo[];
  subdirs: string[];
}

export interface ExtractionResult {
  exports: string[];
  imports: string[];
}

export interface Config {
  exclude: {
    directories: string[];
    files: string[];
  };
  include: {
    extensions: string[];
  };
}

export interface CLIOptions {
  recursive: boolean;
  depth?: number;
  dryRun: boolean;
  force: boolean;
  quiet: boolean;
  verbose: boolean;
}

export type WriteResult = 'WRITTEN' | 'SKIPPED' | 'DRY_RUN';
