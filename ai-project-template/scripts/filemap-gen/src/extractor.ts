import { Project, SyntaxKind, type SourceFile } from 'ts-morph';
import type { ExtractionResult } from './types.js';

const project = new Project({
  skipAddingFilesFromTsConfig: true,
  skipFileDependencyResolution: true,
});

export function extractFile(filePath: string): ExtractionResult {
  try {
    const sourceFile = project.addSourceFileAtPath(filePath);
    const result = {
      exports: getExports(sourceFile),
      imports: getImports(sourceFile),
    };
    project.removeSourceFile(sourceFile);
    return result;
  } catch {
    return { exports: [], imports: [] };
  }
}

function getExports(sourceFile: SourceFile): string[] {
  const exports: string[] = [];

  const exportedDeclarations = sourceFile.getExportedDeclarations();
  exportedDeclarations.forEach((declarations, name) => {
    if (name !== 'default') {
      exports.push(name);
    } else {
      for (const decl of declarations) {
        const defaultName = getDefaultExportName(decl);
        if (defaultName) {
          exports.push(defaultName);
        }
      }
    }
  });

  return [...new Set(exports)].sort();
}

function getDefaultExportName(node: ReturnType<SourceFile['getExportedDeclarations']> extends Map<string, infer V> ? V extends (infer U)[] ? U : never : never): string | null {
  if ('getName' in node && typeof node.getName === 'function') {
    const name = node.getName();
    if (name) return name;
  }

  const parent = node.getParent();
  if (parent && parent.getKind() === SyntaxKind.ExportAssignment) {
    const text = node.getText();
    if (text.length < 50 && /^[a-zA-Z_$][a-zA-Z0-9_$]*$/.test(text)) {
      return text;
    }
  }

  return 'default';
}

function getImports(sourceFile: SourceFile): string[] {
  const imports: string[] = [];

  for (const imp of sourceFile.getImportDeclarations()) {
    const moduleSpecifier = imp.getModuleSpecifierValue();
    imports.push(moduleSpecifier);
  }

  sourceFile.getDescendantsOfKind(SyntaxKind.CallExpression).forEach((call) => {
    const expr = call.getExpression();
    if (expr.getKind() === SyntaxKind.ImportKeyword) {
      const args = call.getArguments();
      if (args.length > 0) {
        const arg = args[0].getText().replace(/['"]/g, '');
        if (arg && !arg.includes('$')) {
          imports.push(arg);
        }
      }
    }
  });

  return [...new Set(imports)].sort();
}
