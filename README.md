
# 2D RPG Game (Godot Engine)

[![Watch the video](https://raw.githubusercontent.com/SRVSRR/Top-Down-2D-RPG/main/Map_Image)](https://raw.githubusercontent.com/SRVSRR/Top-Down-2D-RPG/main/Inventory_Pickup_Showcase)

## **Game Overview**
This is a top-down, open-world RPG developed in the **Godot Engine**, using **GDScript**, where players explore different scenes, engage in combat, and manage health during battles. The game includes an **attack system** with health bars and **health regeneration mechanics**.


## **Features**

### 🎮 **Core Gameplay**
- **Open World**: Explore a seamless and engaging open-world environment.
- **Scene Changes**: Smooth transitions between different scenes (e.g., towns, forests, caves).
- **Combat System**:
  - **Attack Mechanic**: Players can attack enemies with visual feedback.
  - **Health Bars**: Both players and enemies have health bars.
  - **Health Regeneration**: After 3 seconds without taking damage, health regenerates gradually.

## **Game Structure**

### **Directories and Files**
- **Scenes**: Contains all game scenes (e.g., main menu, world map, battle zones).
- **Scripts**: All GDScript files for gameplay mechanics (e.g., attack, health, scene management).
- **Assets**: Art, sound, and other resources.

### **Scripts**
1. **Player.gd**:
   - Handles player movement, attack, and health regeneration.
2. **Enemy.gd**:
   - Pathfinding and tracking for enemy attacks, health tracking, and interactions.
3. **SceneManager.gd**:
   - Manages transitions between scenes.
4. **HUD.gd**:
   - Updates and displays the health bars.


## **Setup and Installation**

1. **Install Godot Engine**: Make sure you have Godot (v4.x recommended) installed. Download it from [Godot Engine](https://godotengine.org).
2. **Clone the Repository**: 
   ```bash
   git clone https://github.com/SRVSRR/Top-Down-2D-RPG.git
   ```
3. **Open the Project**:
   - Launch Godot.
   - Click on **Import Project**, navigate to the project folder, and select `project.godot`.
4. **Run the Game**: Press the **Play** button in the Godot editor.


## **Controls**

| **Action**       | **Key/Input**          |
|-------------------|------------------------|
| Move             | Arrow Keys / WASD      |
| Attack           | E                      |
| Open Inventory   | I                      |
| Pick Item        | P                      |
| Hotbar Select    | 1 - 8                  |


## **Future Improvements**
- Add NPC interactions and quests.
- Expand the open-world map with more scenes.
- Introduce multiple weapons and attack styles.

## **Acknowledgements** 
Here are the list of sources and tutorials I used to make this game. 

Feel free to explore, contribute, or adapt the game for your creative ideas. Enjoy playing! 😊 
