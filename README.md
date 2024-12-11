# Assignment4_PokeCatch-Explorer
 iOS Assignment4

# Pokemon Explorer App

## Overview
This is an app that allows users to explore and capture Pokémon, offering a fun and interactive experience. Users can view Pokémon images and names in a list, click to see details, and try to capture them. The app features a probability-based capture mechanism, making it both challenging and entertaining. Once captured, Pokémon are marked in the list and can be viewed in a dedicated "Caught Pokémon" section. A one-click feature to clear all caught Pokémon is also provided.

---

## Key Features

1. **Browse Pokémon List**  
   - Users can browse a list of Pokémon, displaying their names and images.
   - Clicking on a Pokémon navigates to a detailed view showing more information.

2. **Capture Pokémon**  
   - In the details view, users can attempt to capture Pokémon.
   - Capture mechanism: Based on probability, a capture attempt may succeed or fail.
   - Successfully captured Pokémon are marked in the list.

3. **View Caught Pokémon**  
   - A dedicated section displays all Pokémon that the user has successfully captured.
   - Easy management of captured Pokémon data.

4. **Clear Captured Pokémon**  
   - Provides a one-click option to clear all caught Pokémon data.

---

## Data Source
- All Pokémon images, names, and details in this app are retrieved from the [PokeAPI](https://pokeapi.co/) API.

---

## Technical Stack

### Data Persistence
- **Core Data** is used to manage the user's captured Pokémon records.
- Supports CRUD operations and local data storage.

### UI Design
- Designed using **Auto Layout** and **Constraints** to ensure responsive layouts that adapt to various device sizes.

### View Controllers
- **PokemonListViewController**  
  - Displays a list of Pokémon, supports navigation to the details view, and marks captured Pokémon.

- **PokemonDetailViewController**  
  - Shows detailed Pokémon information (images, descriptions) and allows users to capture Pokémon.

- **CaughtPokemonsViewController**  
  - Manages and displays all Pokémon captured by the user.

---

## How to Use
1. Browse the Pokémon list and click on a Pokémon to see its details.
2. Attempt to capture Pokémon in the detail view.
3. View your captured Pokémon in the dedicated "Caught Pokémon" section.
4. Use the one-click clear feature to reset captured Pokémon data.
