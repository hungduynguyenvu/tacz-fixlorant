This mod modifies TaCZ to allow .lua spread calculation scripts to access player states, such as ADS, sneaking, moving, midair.
api:isMoving() returns true if the player is moving, otherwise false.
api:isOnGround() returns true if the player is on the ground, otherwise false.
api:isCrouching()returns true if the player is sneaking, otherwise false.

Ultimately, it allows changing how recoil pattern and accuracy works from vanilla TaCZ using a .lua script.
One example is that it can allow for movement penalty even while using ADS, which is not achievable through vanilla TaCZ.
