/**
 * Copyright (c) 2023 Cisco Systems, Inc. and its affiliates All rights reserved.
 * Use of this source code is governed by a BSD-style
 * license that can be found in the LICENSE file.
 */

import { defineConfig } from 'vite';
import react from '@vitejs/plugin-react';

const codespaceName = process.env.CODESPACE_NAME;
const baseUrl = codespaceName ? `https://${codespaceName}-3000.githubpreview.dev` : 'http://localhost:3000';

export default defineConfig({
  plugins: [react()],
  server: {
    port: 3000,
    proxy: {
      '/auth': {
        target: codespaceName ? `https://${codespaceName}-8000.githubpreview.dev` : 'http://localhost:8000',
        changeOrigin: true,
      },
      '/atm': {
        target: codespaceName ? `https://${codespaceName}-8001.githubpreview.dev` : 'http://localhost:8001',
        changeOrigin: true,
      },
    },
    watch: {
      usePolling: true,
    },
    host: true,
  },
});
