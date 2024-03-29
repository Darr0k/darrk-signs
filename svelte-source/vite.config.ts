import { defineConfig } from 'vite'
import { svelte } from '@sveltejs/vite-plugin-svelte'
import { resolve } from "path";

// https://vitejs.dev/config/
export default defineConfig({
  plugins: [svelte({})],
  base: './', // fivem nui needs to have local dir reference
  resolve: {
    alias: {
      "@assets": resolve("./src/assets"),
      "@components": resolve("./src/components"),
      "@providers": resolve("./src/providers"),
      "@store": resolve("./src/store"),
      "@utils": resolve("./src/utils"),
      "@typings": resolve("./src/typings"),
      "@layout": resolve("./src/layout"),
      "@pages": resolve("./src/pages"),
    },
  },
  build: {
    emptyOutDir: true,
    outDir: '../html',
    assetsDir: './',
    rollupOptions: {
      output: {
        // By not having hashes in the name, you don't have to update the manifest, yay!
        entryFileNames: `[name].js`,
        chunkFileNames: `[name].js`,
        assetFileNames: `[name].[ext]`
      }
    }
  }
  
})