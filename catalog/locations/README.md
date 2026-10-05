# Locations

Each JSON file describes one location template and its nested scenes.

Locations are displayed on the map and may contain additional scenes with descriptions, images, and quests.

Some locations appear on the map automatically. For example, these may be natural features placed in the map template's `locationSlots`.

The player can build other locations themselves by spending the number of diamonds specified in the location's `buildPrice`.

These methods are not necessarily mutually exclusive: a buildable location may also be used in `locationSlots` if it matches the slot's restrictions.

Rules for placing locations on maps are described in [`../maps/README.md`](../maps/README.md).

Location scenes may include a transition to quests. To do this, specify the quest's `templateId` in the scene's `questTemplateId` field. 

Quest structure is described in [`../quests/README.md`](../quests/README.md).

General catalog guidelines are in [`catalog/README.md`](../README.md).

## Complete example

Example of a location that can be added to a map through the map template's `locationSlots`:

```json
{
  "templateId": "old-grotto",
  "name": "Old Grotto",
  "description": "An ancient grotto in a hillside.",
  "sourceImageUrl": "https://example.org/old-grotto.png",
  "type": "CAVE",
  "buildPrice": null,
  "scenes": [
    {
      "templateId": "entrance",
      "name": "Grotto Entrance",
      "description": "A stone staircase descends into darkness.",
      "sourceImageUrl": "https://example.org/old-grotto-entrance.png",
      "sceneNumber": 1
    },
    {
      "templateId": "underground-hall",
      "name": "Underground Hall",
      "description": "Beyond a narrow passage lies a large underground hall.",
      "sourceImageUrl": "https://example.org/old-grotto-hall.png",
      "sceneNumber": 2,
      "questTemplateId": "first-hatches",
      "questButtonText": "Examine the old hatch"
    }
  ],
  "allowedAcquisitionSources": []
}
```

Example of a location that can be added to the inventory and then built by the player:

```json
{
  "templateId": "city-fountain",
  "name": "City Fountain",
  "description": "...",
  "sourceImageUrl": "https://example.org/city-fountain.png",
  "type": "FOUNTAIN",
  "buildPrice": 50,
  "scenes": [
    {
      "templateId": "blue-water",
      "name": "Murmuring Water",
      "description": "Bubbles and splashes scatter the light.",
      "sourceImageUrl": "https://example.org/fountain-blue-water.png",
      "sceneNumber": 1
    },
    {
      "templateId": "fish-in-the-fountain",
      "name": "Fish Live Here",
      "description": "Fish shadows flicker on the bottom, but they are hard to make out.",
      "sourceImageUrl": "https://example.org/fish-in-the-fountain.png",
      "sceneNumber": 2,
      "questTemplateId": "watch-fish",
      "questButtonText": "Try to make out the fish"
    }
  ],
  "allowedAcquisitionSources": [
    "SHOP",
    "QUEST_REWARD"
  ]
}
```

In a working branch, a temporary public `sourceImageUrl` can be used instead of `imageKey`, according to the [general image guidelines](../README.md).

Before publishing the catalog, temporary links are replaced with `imageKey` values.

## Location fields

### `templateId`

The required stable identifier of the location template.

```json
{
  "templateId": "old-grotto"
}
```

`templateId`:

* must be a nonempty string;
* must be unique among all locations;
* is preserved when editing an existing location.

Changing `templateId` means deleting the old template and adding a new one.

### `name`

The required location name displayed to the player.

```json
{
  "name": "Old Grotto"
}
```

### `description`

The required main location description.

```json
{
  "description": "An ancient grotto in a hillside."
}
```

### Image

The location must have an image.

In the author's working branch, the following is allowed:

```json
{
  "sourceImageUrl": "https://example.org/old-grotto.png"
}
```

The published catalog uses:

```json
{
  "imageKey": "locations/old-grotto.webp"
}
```

Do not specify `imageKey` and `sourceImageUrl` at the same time.

## Location type

The `type` field is required and determines the location type.

```json
{
  "type": "CAVE"
}
```

Allowed types:

* `PARK` — a park;
* `MONUMENT` — a monument;
* `LANDMARK` — a landmark;
* `PAVILION` — a tent;
* `CAVE` — a cave or grotto;
* `FOUNTAIN` — a fountain;
* `RESORT` — a resort;
* `WATERFALL` — a waterfall;
* `RUINS` — ruins;
* `WATER_LOCATION` — a location placed on the water portion of a map.

This is not a strict semantic classification. 

`type` must be one of the values listed above, but is used primarily for technical purposes, 
particularly by the mobile app to choose the location icon on the map. 
The type name therefore does not have to describe the object literally. 
For example, a traveling musicians' camp can be classified as `PAVILION`, and an amusement park as `PARK`.

`WATER_LOCATION` is a technical placement type, not an indication that the object is associated with water in the story.
Use this type only for a location that can actually be placed on the water portion of the map: for example, an island, a sunken ship, or an object in the middle of a lake or sea.
A grove, park, or other land feature does not become a `WATER_LOCATION` just because its description mentions rain, a pond, or a river.

The `type` field defines a broad category. More precise technical properties for random placement are specified through `tags`.

The type may also be used by map slots to restrict random location placement through `allowedTypes`.

For example, the slot:

```json
{
  "allowedTypes": [
    "WATERFALL"
  ]
}
```

can be filled only by a location of type `WATERFALL`.

For details, see [`../maps/README.md`](../maps/README.md).

## Placement tags

The optional `tags` field contains technical location properties that RANDOM map slots may use.

```json
{
  "tags": [
    "lake",
    "shallow-water"
  ]
}
```

Tags are not user-facing descriptions and do not replace `type`. Add them only when a map needs to select locations by a more specific property than type.

Rules:

* `tags` may be omitted or set to `null` if there are no additional properties;
* each tag must be a nonempty string;
* the same tag should not repeat within a location;
* the set of allowed tags is not a closed enum and may expand with game content;
* a tag's meaning must be technical and sufficiently stable for map placement.

For example, several locations of type `WATER_LOCATION` may differ in their `lake`, `sea`, `shore`, and `deep-water` tags. A map slot can then require not just any water location, but one matching all specified tags.

For details on `requiredTags`, see [`../maps/README.md`](../maps/README.md).

## Construction cost

`buildPrice` specifies the cost in diamonds of building the location by the player.

```json
{
  "buildPrice": 50
}
```

Values:

* `null` or an absent field — the player cannot build this location themselves;
* `0` — the location can be built for free;
* a positive integer — the construction cost in diamonds.

Natural locations that appear automatically on the map usually have:

```json
{
  "buildPrice": null
}
```

`buildPrice: null` or an absent `buildPrice` means the player cannot build the location, and the location must not enter the inventory. 
Such locations should specify `allowedAcquisitionSources` as an empty array `[]`.

Such a location will not enter the inventory separately, but can be added to the map automatically through the map's `locationSlots`. 
In this case, the player receives it already placed and does not build anything.

## Scenes

The `scenes` field contains the location's additional scenes.

```json
{
  "scenes": [
    {
      "templateId": "entrance",
      "description": "The cave entrance.",
      "sceneNumber": 1
    }
  ]
}
```

Scenes are displayed in the location gallery after the location's main card.

The array may be empty if the location has no additional scenes.

## Scene `templateId`

Each scene has its own stable `templateId`.

```json
{
  "templateId": "underground-hall"
}
```

It must be:

* nonempty;
* unique within this location;
* stable when editing an existing scene.

A scene's `templateId` is its identifier.

Scene order is determined separately through `sceneNumber`.

## Scene numbering

`sceneNumber` is a required positive integer determining scene order in the gallery.

```json
{
  "sceneNumber": 1
}
```

Scenes are usually numbered starting at `1`.

For example:

```text
1, 2, 3
```

or:

```text
1, 5, 10
```

Both options are valid.

Requirements:

* `sceneNumber` must be a positive integer;
* numbers must be unique within a location;
* continuous numbering is not required;
* a lower value is displayed before a higher one.

`sceneNumber` is not a scene identifier. When changing scene order, their `sceneNumber` values may be changed without changing `templateId`.

The location's main card is not included in this numbering and is always displayed before additional scenes.

## Scene fields

A scene may have a name:

```json
{
  "name": "Underground Hall"
}
```

The name is optional.

The scene description is required:

```json
{
  "description": "Beyond a narrow passage lies a large underground hall."
}
```

A scene must also have an image:

```json
{
  "imageKey": "locations/old-grotto/underground-hall.webp"
}
```

In a working branch, a temporary `sourceImageUrl` is allowed instead of `imageKey`.

## Linking a scene to a quest

A scene can launch a quest.

This uses `questTemplateId`:

```json
{
  "questTemplateId": "first-hatches"
}
```

The value must match the `templateId` of an existing quest in [`../quests/`](../quests/).

If `questTemplateId` is absent, the scene does not launch a quest.

### Quest button text

For a scene with a quest, custom button text can be specified:

```json
{
  "questTemplateId": "first-hatches",
  "questButtonText": "Examine the old hatch"
}
```

`questButtonText` is optional.

If it is absent, the mobile app uses the default text for the button that opens a quest.

Do not specify `questButtonText` without `questTemplateId`.

## Scene changes after a quest

A quest can change the location scene after a particular ending is reached.

These changes are specified not in the location JSON, but through `scenePatch` on the quest's final page.

For example, a closed hatch may become open after completing a quest.

The `scenePatch` rules are described in [`../quests/README.md`](../quests/README.md).

## Acquisition sources

A location's standard acquisition sources can be restricted through `allowedAcquisitionSources`.

A location created together with the map through `locationSlots` is already placed on the map and does not enter the inventory. 

Therefore, `allowedAcquisitionSources` does not affect filling the map's `locationSlots`.

Example for a separate location:

```json
{
  "allowedAcquisitionSources": [
    "QUEST_REWARD",
    "EXPEDITION_REWARD"
  ]
}
```

General rules and allowed values are described in the [acquisition sources section](../README.md#acquisition-sources).

An absent `allowedAcquisitionSources` or a value of `null` means there are no restrictions.

An empty array means the location cannot be obtained through any standard source, 
but it may be placed on the map automatically.

## Validation

Before opening a pull request, check:

* the location's `templateId` is specified and unique among locations;
* `name` and `description` are specified;
* `type` matches one of the allowed location types;
* `buildPrice`, if specified, is a nonnegative integer;
* if `buildPrice` is absent or `null`, `allowedAcquisitionSources` is `[]`;
* if a location is to be granted separately to the inventory, it has a `buildPrice`;
* the image is provided through `sourceImageUrl` or `imageKey`;
* each scene's `templateId` is specified and unique within the location;
* each scene's `sceneNumber` is a positive integer;
* `sceneNumber` does not repeat within a location;
* each scene's description and image are specified;
* every `questTemplateId` references an existing quest;
* `questButtonText` is not specified without `questTemplateId`;
* `allowedAcquisitionSources` values, if specified, are valid acquisition sources;
* temporary `sourceImageUrl` values are replaced with `imageKey` before publication.
