{{flutter_js}}
{{flutter_build_config}}
_flutter.loader.load({
  onEntrypointLoaded: async function (engineInitializer) {
    const appRunner = await engineInitializer.initializeEngine();
    await appRunner.runApp();

    // Remove splash screen after Flutter app runs
    const splash = document.getElementById("splash");
    if (splash) {
      splash.remove();
    }
  }
});
