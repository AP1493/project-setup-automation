#!/bin/bash
set -e

# ===================================================
# 🚀 UNIVERSAL ENTERPRISE PROJECT SETUP (INTERACTIVE)
# Author: Alay Patel
# ===================================================

echo "============================================="
echo "     🏗️  UNIVERSAL PROJECT SETUP WIZARD"
echo "============================================="

# --- USER INPUTS ---
read -p "👉 Enter the npx create command (e.g. npx create-next-app@latest): " CREATE_CMD
read -p "👉 Enter your project name: " PROJECT_NAME
read -p "👉 Use TypeScript? (y/n): " USE_TS
read -p "🔍 Add ESLint + Prettier + Airbnb rules? (y/n): " ADD_LINT
read -p "🐶 Add Husky + lint-staged + commitlint? (y/n): " ADD_HUSKY
read -p "🧪 Add testing framework (jest/cypress/none) [j/c/n]: " TEST_FRAMEWORK
read -p "⚙️ Add GitHub Actions CI/CD workflow? (y/n): " ADD_CI
read -p "🌐 Initialize & push to GitHub? (y/n): " ADD_GIT

if [[ "$ADD_GIT" == "y" ]]; then
  read -p "📦 Enter your GitHub repo name: " REPO_NAME
  read -p "📝 Enter your commit type (e.g. feat, chore, bug): " COMMIT_TYPE
  read -p "📝 Enter commit title (max 80 chars): " COMMIT_TITLE
  read -p "📝 Enter commit body (each line <= 80 chars): " COMMIT_BODY
fi

# --- PROJECT CREATION ---
echo "📦 Creating project..."
if [[ "$USE_TS" == "y" ]]; then
  $CREATE_CMD "$PROJECT_NAME" --typescript --use-pnpm
else
  $CREATE_CMD "$PROJECT_NAME" --use-pnpm
fi

cd "$PROJECT_NAME"

# --- LINTING SETUP ---
if [[ "$ADD_LINT" == "y" ]]; then
  echo "🔧 Setting up ESLint + Prettier..."
  pnpm install -D eslint prettier eslint-config-prettier eslint-plugin-prettier \
    eslint-config-airbnb eslint-plugin-import eslint-plugin-jsx-a11y \
    eslint-plugin-react eslint-plugin-react-hooks \
    @typescript-eslint/parser @typescript-eslint/eslint-plugin

  cat > .eslintrc.json << 'EOF'
{
  "extends": [
    "airbnb",
    "airbnb/hooks",
    "plugin:@typescript-eslint/recommended",
    "plugin:react/recommended",
    "plugin:react-hooks/recommended",
    "plugin:jsx-a11y/recommended",
    "plugin:prettier/recommended"
  ],
  "plugins": ["@typescript-eslint", "react", "react-hooks", "jsx-a11y", "prettier"],
  "parser": "@typescript-eslint/parser",
  "rules": {
    "prettier/prettier": "error",
    "react/react-in-jsx-scope": "off",
    "react/prop-types": "off",
    "@typescript-eslint/no-unused-vars": ["error"],
    "no-console": "warn",
    "import/extensions": "off"
  },
  "settings": {
    "react": {
      "version": "detect"
    },
    "import/resolver": {
      "node": {
        "extensions": [".js", ".jsx", ".ts", ".tsx"]
      }
    }
  }
}
EOF

  cat > .prettierrc << 'EOF'
{
  "printWidth": 80,
  "tabWidth": 2,
  "semi": true,
  "singleQuote": true,
  "trailingComma": "all",
  "arrowParens": "always",
  "endOfLine": "lf"
}
EOF

  pnpm pkg set scripts.lint="eslint 'src/**/*.{ts,tsx,js,jsx}' --max-warnings=0"
fi

# --- HUSKY + COMMITLINT ---
if [[ "$ADD_HUSKY" == "y" ]]; then
  echo "🐶 Adding Husky + lint-staged + commitlint..."
  pnpm install -D husky lint-staged @commitlint/{config-conventional,cli}

  pnpm dlx husky-init .husky
  cat > .husky/pre-commit << 'EOF'
#!/usr/bin/env sh
. "$(dirname -- "$0")/_/husky.sh"
pnpm lint-staged
EOF
  chmod +x .husky/pre-commit

  cat > .husky/commit-msg << 'EOF'
#!/usr/bin/env sh
. "$(dirname -- "$0")/_/husky.sh"
pnpm commitlint --edit "$1"
EOF
  chmod +x .husky/commit-msg

  cat > .lintstagedrc.json << 'EOF'
{
  "src/**/*.{ts,tsx,js,jsx}": [
    "prettier --write"
  ]
}
EOF

  cat > commitlint.config.js << 'EOF'
module.exports = {
  extends: ['@commitlint/config-conventional'],
  rules: {
    'header-max-length': [2, 'always', 80],
    'type-enum': [
      2,
      'always',
      ['feat', 'chore', 'bug']
    ]
  }
};
EOF
fi

# --- JEST SETUP ---
if [[ "$TEST_FRAMEWORK" == "j" ]]; then
  echo "🧪 Setting up Jest with sample test..."
  pnpm install -D jest @testing-library/react @testing-library/jest-dom \
    @testing-library/user-event jest-environment-jsdom ts-jest @types/jest

  cat > jest.config.js << 'EOF'
const nextJest = require('next/jest');
const createJestConfig = nextJest({ dir: './' });

const customJestConfig = {
  setupFilesAfterEnv: ['<rootDir>/jest.setup.ts'],
  testEnvironment: 'jest-environment-jsdom',
  moduleNameMapper: {
    '^@/(.*)$': '<rootDir>/src/$1'
  }
};

module.exports = createJestConfig(customJestConfig);
EOF

  cat > jest.setup.ts << 'EOF'
import '@testing-library/jest-dom';
EOF

  mkdir -p src/__tests__
  cat > src/__tests__/sample.test.tsx << 'EOF'
import { render, screen } from '@testing-library/react';
import React from 'react';

const Dummy = () => <div>Hello Test</div>;

test('renders dummy component', () => {
  render(<Dummy />);
  expect(screen.getByText('Hello Test')).toBeInTheDocument();
});
EOF

  pnpm pkg set scripts.test="jest --watchAll=false"
  pnpm pkg set scripts['test:ci']="jest --ci --runInBand --passWithNoTests"

# --- CYPRESS SETUP ---
elif [[ "$TEST_FRAMEWORK" == "c" ]]; then
  echo "🧪 Setting up Cypress with unit and functional tests..."
  pnpm install -D cypress @cypress/react @cypress/vite-dev-server \
    @testing-library/cypress tsconfig-paths

  if [[ "$USE_TS" == "y" ]]; then
    pnpm install -D @types/cypress
  fi
  # Initialize Cypress
  pnpm cypress install

  # Create Cypress configuration
  cat > cypress.config.ts << 'EOF'
const { defineConfig } = require('cypress')

module.exports = defineConfig({
  e2e: {
    // e2e options here
  },
})
EOF

  # Create sample unit test
  mkdir -p src/components
  cat > src/components/Dummy.tsx << 'EOF'
import React from 'react';

export const Dummy = () => {
  return <div data-testid="dummy-component">Hello Test</div>;
};
EOF

  mkdir -p src/__tests__
cat > src/__tests__/Dummy.cy.tsx << 'EOF'
import { Dummy } from '../components/Dummy';

describe('Dummy Component', () => {
  it('renders correctly', () => {
    cy.mount(<Dummy />);
    cy.dataTest('dummy-component').should('have.text', 'Hello Test');
  });
});
EOF

  # Create sample functional test
  mkdir -p cypress/e2e
  cat > cypress/e2e/home.cy.ts << 'EOF'
describe('Google Home Page', () => {
  it('visits google.com and checks for the Google logo', () => {
    cy.visit('https://www.google.com');
    cy.get('.lnXdpd').should('be.visible');
  });
});
EOF

  # Update package.json scripts
  pnpm pkg set scripts['cy:open']="cypress open"
  pnpm pkg set scripts['cy:run']="cypress run"
  pnpm pkg set scripts['test']="cypress run --component"
  pnpm pkg set scripts['test:ci']="pnpm cypress run --e2e --browser chrome --headless"

fi

# --- GITHUB ACTIONS CI/CD ---
if [[ "$ADD_CI" == "y" ]]; then
  echo "⚙️ Setting up GitHub Actions CI/CD..."
  mkdir -p .github/workflows
  cat > .github/workflows/ci.yml << 'EOF'
name: CI Pipeline

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  build:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v4

      - name: Use Node.js 20
        uses: actions/setup-node@v4
        with:
          node-version: 20

      - name: Setup pnpm
        uses: pnpm/action-setup@v3
        with:
          version: 8
          run_install: false

      - name: Install dependencies
        run: pnpm install

      - name: Run Tests
        run: pnpm test:ci

      - name: Build project
        run: pnpm build
EOF
fi

# --- GIT + GITHUB REPO SETUP ---
if [[ "$ADD_GIT" == "y" ]]; then
  echo "🧬 Initializing Git repo..."
  git init
  git add .
  git commit -m "$COMMIT_TYPE: $COMMIT_TITLE"$'\n\n'"$COMMIT_BODY"

  echo "🌐 Creating GitHub repo..."
  gh repo create "$REPO_NAME" --public --source=. --remote=origin

  echo "📤 Pushing to GitHub..."
  git branch -M main
  git push -u origin main
fi

echo "✅ Setup complete for project: $PROJECT_NAME"
echo "---------------------------------------------"
echo "Next steps:"
echo "  cd $PROJECT_NAME"
echo "  pnpm dev"
if [[ "$TEST_FRAMEWORK" == "c" ]]; then
  echo "  pnpm cy:open # To open Cypress test runner"
fi
echo "---------------------------------------------"
