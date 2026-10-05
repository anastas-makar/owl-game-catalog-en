# Maps

Each file describes one map template and its location and enemy slots.

## Maps in the game

In the game, maps are in the "My Domains" section. 

The first map a player receives is always free, because playing is impossible without a free map. 

A city can be founded on a free map. Houses and castles can be built in a city. Animals can settle in houses and castles.

The map may also contain locations (described in [`../locations/`](../locations/)). 

Some locations, usually natural features, are selected randomly and arrive together with the map. 

For such locations, the map template specifies `locationSlots`. 

If `locationSlots` are positioned and restricted correctly, anomalies such as ruins appearing in water or a waterfall in a forest will not occur. 

To achieve this, slots can restrict allowed location types.

The player can build other locations in the city themselves. In this case, they decide what to place and where. 

Houses and castles in cities can be grouped into streets. 

A city mayor can be chosen from the animals living in that city. A mayor may live in either a castle or a house.

Cities can be grouped into countries. A country ruler can be chosen from the animals living in that country.

A country ruler must live in a castle. 

All maps except the first are occupied by enemies. Enemies are described in [`../enemies/`](../enemies/). 

The map template specifies `enemySlots` for enemies. 

Enemy slots serve the same purpose as location slots: they prevent anomalies. Enemies are selected randomly and placed in suitable map slots. 

To liberate an occupied map, send an animal on an expedition equipped with enough supplies, scales, and small bombs that provide attack and defense points.

General catalog guidelines are in [`catalog/README.md`](../README.md).

## Example

```json
{
  "templateId": "swamp-map",
  "name": "Marshland",
  "sourceImageUrl": "https://example.org/swamp-map.png",
  "completionMedalTemplateId": "swamp-liberator",
  "completionLootBundle": {
    "diamondLoot": {
      "amount": 20
    }
  },
  "locationSlots": [],
  "enemySlots": []
}
```

The published catalog uses `imageKey` instead of `sourceImageUrl`. For details, see the general image guidelines in [`catalog/README.md`](../README.md).

## Slots

A slot is not a standalone catalog template. It describes a stable place within a particular map, so it uses `slotId` rather than `templateId`.

`slotId` must be unique within the corresponding slot array of a map.

The same `slotId` may be used in different maps.

After a map is published, `slotId` is considered stable. If slot parameters change but `slotId` remains, this is a change to an existing slot. If an old `slotId` disappears and a new one appears, one slot has been deleted and another added.

## Location slots

Locations created immediately as part of a map are placed in `locationSlots`. 

Such an instance is already on the map and does not need to be built by the player.

The location template's `allowedAcquisitionSources` does not affect filling `locationSlots`: this field applies only to obtaining the location separately from the map.

A slot can either specify a particular location or restrict random selection to suitable location types and technical tags.

### Fixed location

```json
{
  "slotId": "north-grotto",
  "mode": "FIXED",
  "x": 0.2,
  "y": 0.35,
  "fixedLocationTemplateId": "old-grotto"
}
```

If mode is FIXED, `fixedLocationTemplateId` must reference an existing location in [`../locations/`](../locations/).

### Type restrictions

For randomly selected locations, a slot can restrict allowed types through `allowedTypes`.

For example:

```json
{
    "slotId": "waterfall-slot",
    "mode": "RANDOM",
    "x": 0.6,
    "y": 0.25,
    "allowedTypes": [
      "WATERFALL"
    ]
}
```

Such a slot is suitable only for locations of type `WATERFALL`.

If several allowedTypes values are specified, a location of any of the listed types may be chosen for the slot.

If no type restriction is needed, allowedTypes can be omitted.

Location types have gameplay meaning and are used by the mobile app, particularly to choose the location icon on the map.

### Location types

Available location types:

* `PARK` — a park;
* `MONUMENT` — a monument;
* `LANDMARK` — a landmark;
* `PAVILION` — a tent;
* `CAVE` — a cave;
* `FOUNTAIN` — a fountain;
* `RESORT` — a resort;
* `WATERFALL` — a waterfall;
* `RUINS` — ruins;
* `WATER_LOCATION` — a location placed on the water portion of a map.

`WATER_LOCATION` specifically means a location instance can be placed on the water portion of the map. It is not a general type for any object associated with water in its story or description.

### Tag restrictions

For a RANDOM slot, `requiredTags` may additionally be specified:

```json
{
  "slotId": "quiet-lake",
  "mode": "RANDOM",
  "x": 0.55,
  "y": 0.30,
  "allowedTypes": [
    "WATER_LOCATION"
  ],
  "requiredTags": [
    "lake",
    "shallow-water"
  ]
}
```

A location fits such a slot if both conditions hold:

* its `type` matches at least one value in `allowedTypes` — that is, `allowedTypes` values are combined with **OR**;
* its `tags` contain every tag in `requiredTags` — that is, `requiredTags` values are combined with **AND**.

Thus, `allowedTypes` and `requiredTags` are also applied together. For example, with `allowedTypes: ["WATER_LOCATION", "WATERFALL"]` and `requiredTags: ["lake"]`, a location of type `WATER_LOCATION` **or** `WATERFALL` fits, but only if it has the `lake` tag.

If no tag restriction is needed, `requiredTags` may be omitted or set to `null` or an empty array.

`allowedTypes` and `requiredTags` are allowed only for `mode: "RANDOM"`. Neither filter is set for a `FIXED` slot, since a specific template has already been selected through `fixedLocationTemplateId`.

Location tags are described in [`../locations/README.md`](../locations/README.md).

### Location slot requirements

For all RANDOM slots on a map, there must be an assignment in which each slot receives a distinct suitable location. Locations specified in FIXED slots cannot be used by RANDOM slots.

Several FIXED slots may reference the same location template. Such duplication is considered intentional.

## Enemy slots

Example:

```json
{
  "slotId": "north-gate",
  "x": 0.25,
  "y": 0.4,
  "requiredTags": [
    "swamp"
  ]
}
```

`requiredTags` restricts enemy selection by their technical tags.

### Enemy slot requirements

If the catalog has no enemies matching a slot's requirements, the validator reports an error. Enemies may repeat.

## Coordinates

`x` and `y` specify the slot's position on the map.

Coordinates range from 0 to 1, expressed as fractions of one. The map's length and width are both 1.

## Map liberation reward

An expedition always liberates a map. A map can be successfully liberated only once, so its liberation reward is also granted only once.

Every map must contain:

* a liberation medal in `completionMedalTemplateId`;
* liberation loot in `completionLootBundle`.

### Medal

```json
{
  "completionMedalTemplateId": "swamp-liberator"
}
```

`completionMedalTemplateId` must reference an existing medal in [`../medals/`](../medals/).

For details on medals, see the [medal documentation](../medals/README.md).

### Loot

Loot for successfully completing an expedition is specified through `completionLootBundle`.

For example:

```json
{
  "completionLootBundle": {
    "diamondLoot": {
      "amount": 20
    }
  }
}
```

`completionLootBundle` must contain at least one reward.

Templates listed in `completionLootBundle` must be available through `EXPEDITION_REWARD`.

The full `lootBundle` structure, random selection rules, `amount`, and `dropChance` are described in the [loot documentation](../LOOT.md).

## Map acquisition sources

The map itself is a game entity and can be obtained through various standard methods.

If map acquisition methods need to be restricted, use `allowedAcquisitionSources`.

For details, see the ["Acquisition sources" section](../README.md#acquisition-sources).

## Validation

Before opening a pull request, check:

* the map's `templateId` is unique among maps;
* `slotId` values are nonempty and unique within the corresponding array;
* fixed locations reference existing location templates;
* `allowedTypes` values in location slots match existing location types;
* `requiredTags` in RANDOM location slots contain valid nonempty tags;
* for each random location slot, at least one location matches both `allowedTypes` and all `requiredTags`;
* for each enemy slot, at least one enemy matches all `requiredTags`;
* coordinates match the map's coordinate system;
* `completionMedalTemplateId` is specified and references an existing medal;
* `completionLootBundle` is specified, nonempty, and follows the rules in [`LOOT.md`](../LOOT.md);
* templates in `completionLootBundle` are available through `EXPEDITION_REWARD`;
* `allowedAcquisitionSources` values, if specified, are valid acquisition sources;
* the image is provided through `sourceImageUrl` or `imageKey`, rather than added to the repository as a binary file.
