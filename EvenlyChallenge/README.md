# Evenly Developer Challenge – Mobile

** To make this app work, please set the token in the POISearch file

# App description

This app displays a map centered on the Evenly HQ and shows POIs nearby. After clicking on the pin, users can see the name of the place and a button that allows sharing the canonical link to that location.

# Decisions, potential improvements

I used the MVVM architecture. One could add a coordinator to manage navigation, when having an app with larger number of screens. Choosing this architecture pattern helps to separate UI and logic layers, which can improve the testability of the code. I decided to test the logic of adding new annotations and not repeating them in the ViewModel.

Additionally, tokens, base urls, etc., could be retrieved from the config file (could be a remote config).

For the user to see more places, they need to move the map around, and the app will retrieve POIs for the center of the screen. I'm aware of the problem: the user might see results only in the center of the screen. To solve that issue, I'd implement logic determining for which places I would need to do another search to display all existing places on the currently visible part of the map. This option should work only below a specific zoom level to reduce the number of requests. Additionally, I should implement logic for removing annotations when they use too much space. I would start by removing annotations that are the furthest from the center of the map.

