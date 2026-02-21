{ { flutter_js } }
{ { flutter_build_config } }

_flutter.buildRunner.start({
    onEntrypointLoaded: async function (engineInitializer) {
        const appRunner = await engineInitializer.initializeEngine();
        await appRunner.runApp();

        // Remove splash screen after Flutter app runs
        const splash = document.getElementById('splash');
        if (splash) {
            splash.remove();
        }
    }
});
