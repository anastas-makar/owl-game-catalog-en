# Enemies

Each JSON file describes one enemy template.

Enemies are creatures that appear on an occupied map and oppose the player's animal during an expedition.

To liberate the map, the animal must defeat all enemies in the current expedition.

To do so, the animal must have enough attack and defense points to defeat all enemies in succession.

Enemies are scattered across the map and enter combat one at a time. 

The interface shows the player the stats of the animal and its current opponent; the stats of enemies not yet encountered are not shown in advance.

During each battle, the attack and defense points of the animal and the active enemy are gradually spent. 

After defeating one enemy, the animal proceeds to the next with its remaining attack and defense points.

A map can be successfully liberated only once. After victory, enemies no longer appear on it.

An expedition can be lost many times. After a defeat, a new expedition is created and enemies are selected again for it.

Thus, the map template contains only `enemySlots`, which define possible enemy placements, while the specific set of enemies belongs to the created expedition.

For details on maps, expeditions, and `enemySlots`, see [`../maps/README.md`](../maps/README.md).

General catalog guidelines are in [`catalog/README.md`](../README.md).

## Complete example

```json
{
  "templateId": "swamp-ghoul",
  "name": "Swamp Ghoul",
  "description": "A weak swamp opponent.",
  "sourceImageUrl": "https://example.org/swamp-ghoul.png",
  "health": 120,
  "damage": 50,
  "tags": [
    "swamp",
    "weak"
  ]
}
```

In a working branch, a temporary public `sourceImageUrl` can be used instead of `imageKey`.

Before publishing the catalog, temporary links are replaced with `imageKey` values.

## Enemy fields

### `templateId`

The required stable identifier of the enemy template.

```json
{
  "templateId": "swamp-ghoul"
}
```

`templateId`:

* must be a nonempty string;
* must be unique among all enemies;
* is preserved when editing an existing enemy.

Changing `templateId` means deleting the old template and adding a new one.

### `name`

The required enemy name displayed to the player.

```json
{
  "name": "Swamp Ghoul"
}
```

### `description`

The required enemy description.

```json
{
  "description": "A weak swamp opponent."
}
```

### Image

An enemy must have an image.

In a working branch, the following is allowed:

```json
{
  "sourceImageUrl": "https://example.org/swamp-ghoul.png"
}
```

The published catalog uses:

```json
{
  "imageKey": "enemies/swamp-ghoul.webp"
}
```

Do not specify `imageKey` and `sourceImageUrl` at the same time.

## Combat stats

An enemy has two main combat stats:

* `health` — defense points;
* `damage` — attack points.

Example:

```json
{
  "health": 120,
  "damage": 50
}
```

Enemies fight the animal one at a time. During combat, the attack and defense points of the animal and the active enemy are gradually spent. 

If the animal runs out of attack points, it can no longer attack and the expedition ends in defeat. 

If it runs out of defense points, the animal can no longer defend itself and is also defeated.

If the enemy runs out of attack or defense points, it is defeated and the animal proceeds to the next enemy, or wins if there are no enemies left.

Therefore, the expedition outcome does not depend simply on the sum of all enemy stats. 

Consider battle duration when choosing stats. 

If an enemy has many attack points but few defense points, it may be defeated quickly, leaving its remaining attack points unused in the game.

Highly unbalanced health and damage values may produce unexpected gameplay effects, so the proportions of existing enemies should usually serve as a guide.

Do not add combat stats that are absent from the current enemy model.

## Tags

Enemies have no fixed types.

Technical tags in the `tags` field are used to restrict random enemy selection.

For example:

```json
{
  "tags": [
    "swamp",
    "weak"
  ]
}
```

Tags describe enemy properties that may be needed when filling map slots.

Tags:

* must be nonempty strings;
* must not repeat within an enemy;
* must remain stable while used by maps;
* should be added only when the tag has a clear gameplay purpose.

Unlike an enum, the list of allowed tags is not fixed in advance.

If an enemy needs no special restrictions, `tags` can be omitted or left empty.

## Relationship to maps

A map template does not contain a specific set of enemies. Instead, it contains `enemySlots`.

A slot can restrict random enemy selection through `requiredTags`.

For example:

```json
{
  "slotId": "north-swamp",
  "x": 0.25,
  "y": 0.4,
  "requiredTags": [
    "swamp"
  ]
}
```

Such a slot can be filled only by an enemy with the `swamp` tag.

If several `requiredTags` values are specified, the enemy must have all the listed tags.

For example:

```json
{
  "requiredTags": [
    "swamp",
    "weak"
  ]
}
```

this enemy fits the slot:

```json
{
  "tags": [
    "swamp",
    "weak",
    "flying"
  ]
}
```

but this enemy does not:

```json
{
  "tags": [
    "swamp"
  ]
}
```

If `requiredTags` is absent or `null`, the slot can be filled by any existing enemy.

For each `enemySlot`, there must be at least one enemy matching that slot's restrictions.

For details on enemy slots, see [`../maps/README.md`](../maps/README.md).

## Obtaining enemies

Enemies are not player items and are not granted through standard acquisition sources.

The `allowedAcquisitionSources` field is not used for enemies.

Specific enemies are selected automatically when an expedition is created, according to the map's `enemySlots` restrictions.

## Validation

Before opening a pull request, check:

* `templateId` is specified and unique among enemies;
* `name` and `description` are specified;
* the image is provided through `sourceImageUrl` or `imageKey`;
* `health` and `damage` are positive integers chosen with the strength of other enemies in mind;
* `tags`, if specified, are nonempty strings and do not repeat;
* for every tag set used in `enemySlots.requiredTags`, at least one matching enemy exists;
* the `allowedAcquisitionSources` field is not used;
* temporary `sourceImageUrl` values are replaced with `imageKey` before publication.

