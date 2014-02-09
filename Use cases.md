# SnakeDCI - Use cases

## Game start
<pre>
1. Screen clears 
2. Score is set to 0
3. A Snake with 3 segments is created in the middle of the Screen, facing left
4. A Fruit is created on an empty random space of the Screen
5. [Movement] is executed
</pre>

## Rules: Movement control
<pre>
1. Snake moves a step every 7:th frame, decreasing 0.25 for every fruit eaten
2. Using the arrow keys, the Player determines what direction the Snake faces
3. If Player makes the Snake face 180 degrees from its current facing, facing doesn't change
</pre>

## Movement
<pre>
1. The Head of the Snake moves one step across the Screen in the direction Snake is facing
1a.    The Head moves out of the Screen
1a1.       Head wraps around the Screen
1a2.       Use case continues at step 2
2. The Body segments moves to the position of the Segment in front of it
3. [Collisions] are tested
</pre>

## Collisions
<pre>
1. Snake moves to a space where there is a Fruit
1a.    Snake collides with itself
1a1.        A "Game over" text is displayed on the Screen
1a2.        When Player press space, the game restarts according to [Game start]
2. The Fruit disappears from the screen
3. Score increases by 10
4. A segment is added to the end of the Snake
5. A Fruit is placed on an empty random space of the Screen
6. Snake increases its movement speed according to [Rules: Movement control]
6a.    Snake is moving every 2:nd frame
6a1.       [Movement] phase is executed
7. [Movement] phase is executed
</pre>
