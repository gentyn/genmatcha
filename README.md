# Genesis Tyndall - Personal Portfolio

A modern, responsive personal portfolio website built with Astro and Tailwind CSS. This portfolio showcases my experience in embedded systems, test automation, and systems integration, with a focus on my work at Boeing Commercial Airplanes.

## 🚀 Features

- **Modern Design**: Clean, professional interface with dark mode support
- **Responsive Layout**: Optimized for all device sizes
- **Performance**: Built with Astro for optimal performance
- **Styling**: Tailwind CSS for modern, utility-first styling
- **Sections**:
  - Hero section with introduction
  - About section detailing experience and skills
  - Projects showcase
  - Contact form
- **Automated Deployment**: Continuous deployment via GitHub Actions with secure deploy keys and automated testing

## 🛠️ Tech Stack

- [Astro](https://astro.build) - Static Site Generator
- [Tailwind CSS](https://tailwindcss.com) - Utility-first CSS framework
- TypeScript - For type safety
- Node.js - Runtime environment

## 🏗️ Project Structure

```text
/
├── public/          # Static assets
├── src/
│   ├── layouts/     # Page layouts
│   ├── pages/       # Astro pages
│   └── styles/      # Global styles
├── astro.config.mjs # Astro configuration
├── tailwind.config.mjs # Tailwind configuration
└── package.json     # Project dependencies
```

## 🚀 Getting Started

1. **Clone the repository**
   ```bash
   git clone https://github.com/gentyn/genmatcha.git
   cd genmatcha
   ```

2. **Install dependencies**
   ```bash
   npm install
   ```

3. **Start the development server**
   ```bash
   npm run dev
   ```

4. **Build for production**
   ```bash
   npm run build
   ```

## 📝 Available Scripts

| Command | Description |
|---------|-------------|
| `npm run dev` | Start development server |
| `npm run build` | Build for production |
| `npm run preview` | Preview production build |
| `npm run astro check` | Check for TypeScript errors |

## 🔧 Configuration

- `astro.config.mjs` - Astro configuration
- `tailwind.config.mjs` - Tailwind CSS configuration
- `tsconfig.json` - TypeScript configuration

## 📄 License

This project is open source and available under the [MIT License](LICENSE).

## 👤 Contact

- GitHub: [@gentyn](https://github.com/gentyn)
- Portfolio: [genesis-tyndall.com](https://genesis-tyndall.com)

```sh
npm create astro@latest -- --template minimal
```

[![Open in StackBlitz](https://developer.stackblitz.com/img/open_in_stackblitz.svg)](https://stackblitz.com/github/withastro/astro/tree/latest/examples/minimal)
[![Open with CodeSandbox](https://assets.codesandbox.io/github/button-edit-lime.svg)](https://codesandbox.io/p/sandbox/github/withastro/astro/tree/latest/examples/minimal)
[![Open in GitHub Codespaces](https://github.com/codespaces/badge.svg)](https://codespaces.new/withastro/astro?devcontainer_path=.devcontainer/minimal/devcontainer.json)

> 🧑‍🚀 **Seasoned astronaut?** Delete this file. Have fun!

## 🚀 Project Structure

Inside of your Astro project, you'll see the following folders and files:

```text
/
├── public/
├── src/
│   └── pages/
│       └── index.astro
└── package.json
```

Astro looks for `.astro` or `.md` files in the `src/pages/` directory. Each page is exposed as a route based on its file name.

There's nothing special about `src/components/`, but that's where we like to put any Astro/React/Vue/Svelte/Preact components.

Any static assets, like images, can be placed in the `public/` directory.

## 🧞 Commands

All commands are run from the root of the project, from a terminal:

| Command                   | Action                                           |
| :------------------------ | :----------------------------------------------- |
| `npm install`             | Installs dependencies                            |
| `npm run dev`             | Starts local dev server at `localhost:4321`      |
| `npm run build`           | Build your production site to `./dist/`          |
| `npm run preview`         | Preview your build locally, before deploying     |
| `npm run astro ...`       | Run CLI commands like `astro add`, `astro check` |
| `npm run astro -- --help` | Get help using the Astro CLI                     |

## 👀 Want to learn more?

Feel free to check [our documentation](https://docs.astro.build) or jump into our [Discord server](https://astro.build/chat).
