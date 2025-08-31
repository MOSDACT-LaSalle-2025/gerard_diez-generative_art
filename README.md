# Autoexigència - Generative Art Piece
### Gerard Díez Ruiz de los Paños
#### 31/08/1998
---
The sketch is an interactive and generative piece that attempts to portray the feeling of having a thousand eyes on you, as if everyone was watching, whatever you do, due to self-inflicted stress. The screen is filled with eyes positioned following a random distribution (Poisson-Disc sampling) that open and close periodically and follow the user's mouse around. If the computer running this code is powerful, you can try setting the HIGH_PERFORMANCE constant to **true**, which also adds a moving background.

It is a generative piece because a lot of parameters are generated randomly. First, the layout of the eyes is randomized every time. The initial state of each of the eyes is also random. Opening and closing times of each individual eye are random, opened and closed times too.  Each time the eyes close, they are assigned a random color.