# Universal Project Setup Wizard

This repository contains a Bash script designed to automate the setup of enterprise-level web projects, primarily focused on React and Next.js applications. It provides an interactive wizard that handles project creation, linting, pre-commit hooks, testing frameworks, CI/CD workflows, and GitHub integration—all in one go.

## Features
- **Interactive Setup**: Guides you through choices for TypeScript, linting (ESLint + Prettier with Airbnb rules), Husky + lint-staged + commitlint, testing (Jest or Cypress), GitHub Actions CI/CD, and GitHub repo initialization.
- **Project Creation**: Uses `npx create` commands (e.g., `npx create-next-app@latest`) to bootstrap the project with PNPM as the package manager.
- **Linting & Formatting**: Adds ESLint, Prettier, and Airbnb style guides for consistent code quality.
- **Pre-Commit Hooks**: Integrates Husky for Git hooks, lint-staged for staged file linting, and commitlint for conventional commit messages.
- **Testing**: Supports Jest for unit testing or Cypress for end-to-end and component testing, with sample tests included.
- **CI/CD**: Sets up a basic GitHub Actions workflow for building and testing on push/pull requests.
- **GitHub Integration**: Initializes a local Git repo, creates a remote GitHub repo, and pushes the initial commit.
- **Enterprise-Ready**: Emphasizes best practices for scalability, maintainability, and collaboration in professional environments.

This script simplifies onboarding new projects by reducing manual configuration time from hours to minutes, making it ideal for developers, teams, or startups building React/Next.js apps.

## Prerequisites
- **Bash Environment**: Works on Unix-like systems (Linux, macOS, or WSL on Windows).
- **Node.js & PNPM**: Node.js v20+ and PNPM installed globally (`npm install -g pnpm`).
- **Git & GitHub CLI**: Git installed, and GitHub CLI (`gh`) for repo creation (install via `brew install gh` on macOS or similar).
- **npx Compatibility**: Ensure you have access to `npx` (comes with npm).

## Installation & Usage
1. **Clone or Download the Script**:
   - Clone this repo: `git clone https://github.com/your-username/universal-project-setup.git`
   - Or download the `setup.sh` script directly.

2. **Make the Script Executable**:
   - Navigate to the script's directory: `cd universal-project-setup`
   - Run: `chmod +x setup.sh`
     - This grants execute permissions to the Bash script.

3. **Run the Script**:
   - Execute: `./setup.sh`
   - Follow the interactive prompts:
     - Enter the `npx create` command (e.g., `npx create-next-app@latest` for Next.js or `npx create-react-app` for React).
     - Provide project name, preferences for TypeScript, linting, etc.
     - If enabling GitHub, provide repo name and commit details.
   - The script will create the project directory, install dependencies, configure tools, and (optionally) push to GitHub.

4. **Post-Setup**:
   - Navigate to your new project: `cd your-project-name`
   - Start development: `pnpm dev`
   - Run tests: `pnpm test` (or `pnpm cy:open` for Cypress).
   - Lint code: `pnpm lint` (if enabled).

## Example
Running `./setup.sh` might look like this:
```
=============================================
     🏗️  UNIVERSAL PROJECT SETUP WIZARD
=============================================
👉 Enter the npx create command (e.g. npx create-next-app@latest): npx create-next-app@latest
👉 Enter your project name: my-awesome-app
👉 Use TypeScript? (y/n): y
👉 Add ESLint + Prettier + Airbnb rules? (y/n): y
👉 Add Husky + lint-staged + commitlint? (y/n): y
👉 Add testing framework (jest/cypress/none) [j/c/n]: j
👉 Add GitHub Actions CI/CD workflow? (y/n): y
👉 Initialize & push to GitHub? (y/n): y
📦 Enter your GitHub repo name: my-awesome-app
📝 Enter your commit type (e.g. feat, chore, bug): feat
📝 Enter commit title (max 80 chars): Initialize project with setup wizard
📝 Enter commit body (each line <= 80 chars): Setup React/Next.js project with TypeScript, linting, testing, and CI/CD.
...
✅ Setup complete for project: my-awesome-app
```

## Customization
- **Extend the Script**: Add support for other frameworks or tools (e.g., Tailwind CSS, Redux) by modifying `setup.sh`.
- **Error Handling**: The script uses `set -e` to exit on errors. If issues occur (e.g., network failures during `pnpm install`), check terminal output and retry.
- **Framework Support**: Primarily tested with React and Next.js but adaptable to other `npx create` frameworks like Vite.

## Troubleshooting
- **Permission Issues**: Ensure you have execute permissions (`chmod +x setup.sh`) and appropriate write access to the directory.
- **GitHub CLI Errors**: Verify `gh` is authenticated (`gh auth login`) and has permissions to create repos.
- **Dependency Failures**: Ensure a stable internet connection and compatible Node.js/PNPM versions.

## Contributing
Suggestions, bug reports, or pull requests are welcome! Please:
1. Open an issue to discuss bugs or enhancements.
2. Fork the repo, make changes, and submit a PR with clear descriptions.
3. Ensure changes align with the script's goal of simplicity and reliability.

## License
MIT License - Free to use, modify, and distribute.

## Author
Alay Patel