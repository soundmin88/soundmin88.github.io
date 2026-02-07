# How to Deploy Your Portfolio to Vercel

The simplest way to deploy your static website is using the Vercel CLI. This method is free, fast, and gives you a live URL immediately.

## Prerequisites
- You need to have **Node.js** installed (which you likely do).
- You will need to **Sign Up** for a Vercel account at [vercel.com](https://vercel.com) if you haven't already.

## Step 1: Open Your Terminal
Open your terminal (PowerShell or CMD) and make sure you are in the project folder:
`e:\AI_Learning\introduce`

## Step 2: Run the Deploy Command
Run the following command in your terminal:

```bash
npx vercel
```

## Step 3: Follow the Prompts
The command will ask you a few questions. You can mostly press **Enter** to accept the defaults:

1.  **Set up and deploy?** [Y/n] -> Type **Y** and Enter.
2.  **Which scope do you want to deploy to?** -> Select your account (Press Enter).
3.  **Link to existing project?** [y/N] -> Type **N** (since this is new).
4.  **What’s your project’s name?** -> Press Enter (it will use `introduce`) or type `kim-taewoo-portfolio`.
5.  **In which directory is your code located?** -> Press Enter (it should detect `./`).
6.  **Want to modify these settings?** [y/N] -> Type **N**.

## Step 4: Live URL
Once completed, it will show you a **Production** URL (e.g., `https://kim-taewoo-portfolio.vercel.app`).
Click that link to see your live site!

## Alternative: Drag & Drop
If you prefer not to use the command line:
1.  Go to [vercel.com/new](https://vercel.com/new).
2.  Scroll down to "Import a Third-Party Git Repository" -> Skip this.
3.  Look for a section to **Drag & Drop** your folder.
4.  Drag the `introduce` folder into the browser window.
5.  Click **Deploy**.
