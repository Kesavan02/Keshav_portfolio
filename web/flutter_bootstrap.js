{{flutter_js}}
{{flutter_build_config}}

_flutter.loader.load({
  onEntrypointLoaded: async function (engineInitializer) {
    const appRunner = await engineInitializer.initializeEngine();

    // Wait until the Flutter engine has rendered the first frame
    await appRunner.runApp();

    // Now safely remove the loading indicator smoothly
    const loading = document.getElementById('loading');
    if (loading) {
      // Add fade out animation
      loading.style.opacity = '0';
      loading.style.transition = 'opacity 0.5s ease-out';

      // Wait for animation to finish before removing from DOM
      setTimeout(() => {
        loading.remove();
      }, 500);
    }
  }
});
