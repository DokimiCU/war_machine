# `wm_gunslinger` API documentation

This file aims to thoroughly document the `wm_gunslinger` API.

## `wm_gunslinger` namespace

(**Note**: _It's not recommended to directly access the private members of the `wm_gunslinger` namespace_)

The `wm_gunslinger` namespace has the following members:

### "Private" members

- `__guns` [table]: Table of registered guns.
- `__types` [table]: Table of registered types.
- `__automatic` [table]: Table of players weilding automatic guns.
- `__scopes` [table]: Table of HUD IDs of scope overlays.
- `__interval` [table]: Table storing time from last fire; used to regulate fire-rate.

### `wm_gunslinger.register_type(name, def)`

- Registers a type for `name`.
- `def` [table]: [Gun definition table](#gun-definition-table).

### `wm_gunslinger.register_gun(name, def)`

- Registers a gun with the name `name`.
- `def` [table]: [Gun definition table](#gun-definition-table).

### `wm_gunslinger.get_def(name)`

- Retrieves the [Gun definition table](#gun-definition-table).

## Internal methods

### `get_eye_pos(player)`

- Returns position of player eye in `v3f` format.
- Equivalent to

  ```lua
  local pos = player:get_pos()
  pos.y = pos.y + player:get_properties().eye_height
  ```

- `player` [ObjectRef]: Player whose eye position is returned.

### `get_pointed_thing(pos, dir, def)`

- Helper function that performs a raycast from player in the direction of player's look dir, and upto the range defined by `def.range`.
- `pos` [table]: Initial position of raycast.
- `dir` [table]: Direction of raycast.
- `def` [table]: [Gun definition table](#gun-definition-table).

### `play_sound(sound, obj)`

- Helper function to play object-centric sound.
- `sound` [SimpleSoundSpec]: Sound to be played.
- `obj` [ObjectRef]: ObjectRef which is the origin of the played sound.

### `add_auto(name, def, stack)`

- Helper function to add player entry to `automatic` table.
- `def` and `stack` are cached locally for improved performance.
- `name` [string]: Player name.
- `def` [table]: [Gun definition table](#gun-definition-table) of wielded item.
- `stack` [itemstack]: Itemstack of wielded item.

### `show_scope(player, scope, zoom)`

- Activates gun scope, handles placement of HUD scope element.
- `player` [ObjectRef]: Player used for HUD element creation.
- `scope` [string]: Name of scope overlay texture.
- `zoom` [number]: FOV that will override player's default FOV.

### `hide_scope(player)`

- De-activates gun scope, removes HUD element.
- `player` [ObjectRef]: Player to remove HUD element from.

### `on_lclick(stack, player)`

- `on_use` callback for all registered guns. This is where most of the firing logic happens.
- Handles gun firing depending on their `mode`.
- [`reload`] is called when the gun's magazine is empty.
- If `mode` is `"automatic"`, an entry is added to the `automatic` table which is parsed by `on_step`.
- `stack` [ItemStack]: ItemStack of wielditem.
- `player` [ObjectRef]: ObjectRef of user.

### `on_rclick(stack, player)`

- `on_place`/`on_secondary_use` callback for all registered guns. Toggles scope view.
- `stack` [ItemStack]: ItemStack of wielditem.
- `player` [ObjectRef]: Right-clicker.

### `reload(stack, player)` REMOVED

- Reloads stack if ammo exists and plays `def.sounds.reload`. Otherwise, just plays `def.sounds.ooa`.
- Takes the same arguments as `on_lclick`.

### `fire(stack, player)`

- Responsible for firing one single round and dealing damage if target was hit.
- Drains power from energy module. Based on weapon power use
- Takes the same arguments as `on_lclick`.

### `burst_fire(stack, player)`

- Helper method to fire in burst mode.
- Takes the same arguments as `on_lclick`.

### `on_step(dtime)`

- Updates player's time from last shot (`wm_gunslinger.__interval`).
- Calls `fire` for all guns in the `automatic` table if player's LMB is pressed.
- If LMB is released, the respective entry is removed from the table.

## Gun Definition table
Registration uses a point system, rather than the actual values. This is to help create balanced guns i.e. by spending a set budget of points on gun attributes.
These points are converted into actual values.

- `itemdef` [table]: Item definition table passed to `minetest.register_item`.
  - Note that `on_use`, `on_place`, and `on_secondary_use` will be overridden.
- `sounds` [table]: Sounds for various events.
  - `fire` [string]: Sound played on fire. Defaults to `wm_gunslinger_fire.ogg`.
  - `ricochet` [string]: Sound played on hitting ground. Defaults to `wm_gunslinger_ricochet.ogg`.
  - `ooa` [string]: Sound played when the gun is out of ammo and ammo isn't available in the player's inventory. Defaults to `wm_gunslinger_ooa.ogg`.
  - `load` [string]: Sound played when the gun is manually loaded. Only used if `mode` is set to `manual`.
- `ammo` [string]: Name of valid registered item to be used as power source for the gun. Defaults to `wm_gunslinger:ammo`.
- `bullet` [string]: Name of valid registered item to be used as bullet texture. Defaults to `wm_gunslinger:ammo`.
- `mode` [string]: Firing mode.
  - `"semi-automatic"`: One round per-click. e.g. a typical 9mm pistol.
  - `"burst"`: Multiple rounds per-click. Can be set by defining `burst` field. Defaults to 3. e.g. M16A4
  - `"automatic"`: Fully automatic; shoots as long as primary button is held down. e.g. AKM, M416.
  - `"hybrid"`: Same as `"automatic"`, but switches to `"burst"` mode when scope view is toggled.  
- `fire_rate` [number]: Number of rounds per-second. [1 pt = 2 rps.]
- `dmg_mult` [number]: Damage multiplier. Multiplied with `base_dmg` to obtain initial/rated damage value. [1 pt = 1 dmg.]
- `range` [number]: Range of fire in number of nodes. [1 pt = 10 m]
- `pellets` [number]: Number of pellets per-round. Used for firing multiple pellets shotgun-style. Defaults to 1, meaning only one "pellet" is fired each round. [1 pt = 1 pellet.] (must set at least 1 or will be none!)
- `efficiency` [number]: Power usage per shot. ((dmg_mult + fire_rate + range) * pellet #)/((1 + efficiency) * 10))
- `spread_mult` [number]: Spread multiplier. Multiplied with `base_spread` to obtain spread threshold for projectile. Points used to calculate a reduction in spread: (fire_rate +(6*pellets))/ 1 + pts
- `recoil_mult` [number]: Recoil multiplier. Multiplied with `base_recoil` to obtain final recoil per-round. Points used to calculate a reduction in recoil: ((fire_rate + dmg_mult)* pellets)/ (2 + pts.)

- `scope` [string]: Name of scope overlay texture. (NOT FUNCTIONAL?)
  - Overlay texture would be stretched across the screen, and center of texture will be positioned on top of crosshair.
  - Requires `scope` to be defined.

- `round` [string]:
  - `"explosive"`: explodes on impact. (assign 1pt for 1 r. No actual calculations)`boom_radius`[number]  `dmg_radius`[number]
  - `incendiary`: (assign 1pt for 1 r. No actual calculations) `dmg_radius`[number] `fire_count` [number]
