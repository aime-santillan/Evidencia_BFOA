import { defineConfig } from 'vite';
import laravel from 'laravel-vite-plugin';

export default defineConfig({
    plugins: [
        laravel({
            input: [
                'resources/sass/app.scss',
                'resources/js/app.js',
            ],
            refresh: true,
        }),
    ],
    server: {
        host: true,       // escucha en todas las interfaces
        port: 5173,       // puerto
        strictPort: true, // falla si el puerto está ocupado
        hmr: {
            host: 'localhost', // o '127.0.0.1' para Windows
            port: 5173,
        },
    },
});
