# Buildings

Each JSON file in this directory describes one building template, including its rooms and adjoining plots.

Buildings are placed in a city on a liberated map. Animals can live in buildings.

There are two building types:

* `HOUSE` — a house;
* `FORTRESS` — a castle.

`FORTRESS` is the technical type name in the catalog. In the interface, this building is called a castle.

A building contains rooms. Furniture can be placed in rooms. If a room has a refrigerator, the animal can cook dishes from supplies using known recipes.

Each house has a vegetable garden where plants can be grown.

Each castle has a vegetable garden, a garden, and a pond. Appropriate items can be placed in the garden and pond.

Related documentation:

* [Maps](../maps/README.md)
* [Animals](../animals/README.md)
* [Furniture](../furniture/README.md)
* [Recipes](../recipes/README.md)
* [Supplies](../supplies/README.md)
* [Plants](../plants/README.md)
* [Garden and pond items](../garden-items/README.md)

General catalog guidelines are in [`catalog/README.md`](../README.md).

## Key points

* One file — one building.
* The filename matches the root `templateId`.
* Rooms and adjoining plots are nested parts of a building.
* The building is imported as a whole, even if only one room or plot has changed.
* A stable room or plot `templateId` distinguishes editing from deleting and creating a new element.
* A house must have at least one room.
* A castle must have at least two rooms.
* A house must have one vegetable garden and no garden or pond.
* A castle must have a vegetable garden, a garden, and a pond.

## Complete castle example

```json
{
  "templateId": "stone-fortress",
  "name": "Stone Castle",
  "type": "FORTRESS",
  "cost": 5000,
  "sourceImageUrl": "https://example.org/stone-fortress.png",
  "rooms": [
    {
      "templateId": "main-hall",
      "name": "Main Hall",
      "roomNumber": 10,
      "sourceImageUrl": "https://example.org/main-hall.png"
    },
    {
      "templateId": "kitchen",
      "name": "Kitchen",
      "roomNumber": 20,
      "sourceImageUrl": "https://example.org/kitchen.png"
    }
  ],
  "gardens": [
    {
      "templateId": "kitchen-garden",
      "name": "Vegetable Garden",
      "gardenNumber": 10,
      "gardenType": "KITCHEN_GARDEN",
      "sourceImageUrl": "https://example.org/kitchen-garden.png"
    },
    {
      "templateId": "main-garden",
      "name": "Garden",
      "gardenNumber": 20,
      "gardenType": "GARDEN",
      "sourceImageUrl": "https://example.org/main-garden.png"
    },
    {
      "templateId": "pond",
      "name": "Pond",
      "gardenNumber": 30,
      "gardenType": "POOL",
      "sourceImageUrl": "https://example.org/pond.png"
    }
  ]
}
```

In a working branch, a temporary public `sourceImageUrl` can be used instead of `imageKey`.

Before publishing the catalog, temporary links are replaced with `imageKey` values.

## Building fields

### `templateId`

The required stable identifier of the building template.

```json
{
  "templateId": "stone-fortress"
}
```

`templateId`:

* must be a nonempty string;
* must be unique among all buildings;
* is preserved when editing an existing building.

Changing `templateId` means deleting the old template and adding a new one.

### `name`

The required building name displayed to the player.

```json
{
  "name": "Stone Castle"
}
```

### `type`

The building type.

Allowed values:

* `HOUSE` — a house;
* `FORTRESS` — a castle.

The type affects the minimum number of rooms and the set of adjoining plots.

### `cost`

The building's price in diamonds.

```json
{
  "cost": 5000
}
```

A castle should be noticeably more expensive than a house.

While the balance has not been finalized, use the following approximate values:

* houses — approximately `700` to `1500` diamonds;
* castles — approximately `4500` to `5500` diamonds.

These ranges are balance guidelines, not part of the catalog format. If the game economy changes, they can be revised without changing `schemaVersion`.

### Building image

A building must have an image.

In a working branch:

```json
{
  "sourceImageUrl": "https://example.org/stone-fortress.png"
}
```

In the published catalog:

```json
{
  "imageKey": "buildings/stone-fortress.webp"
}
```

Do not specify `imageKey` and `sourceImageUrl` at the same time.

## Rooms

Rooms are described in the `rooms` array.

Each room contains:

* a stable `templateId`;
* a displayed `name`;
* `roomNumber`;
* an image.

Example:

```json
{
  "templateId": "kitchen",
  "name": "Kitchen",
  "roomNumber": 20,
  "sourceImageUrl": "https://example.org/kitchen.png"
}
```

A house must have at least one room.

A castle must have at least two rooms.

### Room `templateId`

`templateId` identifies the room itself and is preserved when it is edited.

For example, if a kitchen is renamed "Large Kitchen", its identifier is preserved:

```json
{
  "templateId": "kitchen",
  "name": "Large Kitchen"
}
```

Replacing `kitchen` with another `templateId` means deleting the old room and adding a new one.

Room identifiers must be unique within a building.

### `roomNumber`

`roomNumber` specifies the room display order.

The mobile app sorts rooms by `roomNumber`.

The number is not a room identifier and does not have to start at `1`.

Gaps are allowed:

```text
10, 20, 30
```

work just as well as:

```text
1, 2, 3
```

This makes it possible to insert a new room between existing ones without renumbering the entire building.

`roomNumber` must be an integer. Room numbers within a building must not repeat, so that the order is unambiguous.

Changing `roomNumber` changes an existing room's position in the gallery but does not create a new room.

### Room image

Every room must have an image.

In a working branch, `sourceImageUrl` can be used; before publication, it is replaced with `imageKey`.

## Vegetable garden, garden, and pond

Adjoining plots are described in the `gardens` array.

The name `gardens` is technical: this array stores not only gardens but also vegetable gardens and ponds.

Each plot contains:

* a stable `templateId`;
* a displayed `name`;
* `gardenNumber`;
* `gardenType`;
* an image.

Allowed `gardenType` values:

* `KITCHEN_GARDEN` — a vegetable garden;
* `GARDEN` — a garden;
* `POOL` — a pond.

### House rules

A building of type `HOUSE` must have a vegetable garden:

```json
{
  "gardenType": "KITCHEN_GARDEN"
}
```

In the current model, a house must have one plot, of type `KITCHEN_GARDEN`.

A house must not have plots of type `GARDEN` or `POOL`.

### Castle rules

A building of type `FORTRESS` must have three plots:

* one `KITCHEN_GARDEN`;
* one `GARDEN`;
* one `POOL`.

For example:

```json
{
  "gardens": [
    {
      "templateId": "kitchen-garden",
      "name": "Vegetable Garden",
      "gardenNumber": 10,
      "gardenType": "KITCHEN_GARDEN",
      "sourceImageUrl": "https://example.org/kitchen-garden.png"
    },
    {
      "templateId": "main-garden",
      "name": "Garden",
      "gardenNumber": 20,
      "gardenType": "GARDEN",
      "sourceImageUrl": "https://example.org/main-garden.png"
    },
    {
      "templateId": "pond",
      "name": "Pond",
      "gardenNumber": 30,
      "gardenType": "POOL",
      "sourceImageUrl": "https://example.org/pond.png"
    }
  ]  
}
```

### Plot `templateId`

A plot's `templateId` is preserved when it is edited.

Plot identifiers must be unique within a building.

### `gardenNumber`

`gardenNumber` specifies the plot display order after the rooms.

The mobile app sorts plots by `gardenNumber`.

The number does not have to start at `1`, and gaps in the sequence are allowed.

For example:

```text
10, 20, 30
```

`gardenNumber` must be an integer. Plot numbers within a building must not repeat, so that the order is unambiguous.

Changing `gardenNumber` changes an existing plot's position in the gallery but does not change its identity.

### Plot image

Every vegetable garden, garden, and pond must have an image.

In a working branch, `sourceImageUrl` can be used; before publication, it is replaced with `imageKey`.

## Acquisition sources

Buildings support the standard `allowedAcquisitionSources` field.

If a building can be obtained through any supported method, the field can be omitted:

```json
{
  "templateId": "small-house"
}
```

If a building is available only through specific sources, specify an allowlist:

```json
{
  "allowedAcquisitionSources": [
    "QUEST_REWARD"
  ]
}
```

An empty list means the building cannot be obtained through any standard method:

```json
{
  "allowedAcquisitionSources": []
}
```

For details on acquisition source semantics, see the [general catalog README](../README.md#acquisition-sources).

## Images

An image is required for:

* the building itself;
* every room;
* every vegetable garden, garden, and pond.

`sourceImageUrl` is allowed in a working pull request.

After transferring an image to the primary S3 storage, `imageKey` is used.

Example:

```json
{
  "imageKey": "buildings/stone-fortress/kitchen.webp"
}
```

Do not specify both fields at the same time.

## Validation before a pull request

Before opening a pull request, check:

* the filename matches the building's `templateId`;
* `name`, `type`, and `cost` are specified;
* `type` is `HOUSE` or `FORTRESS`;
* the building has an image;
* a house has at least one room;
* a castle has at least two rooms;
* every room has `templateId`, `name`, `roomNumber`, and an image;
* room `templateId` values do not repeat within the building;
* room `roomNumber` values do not repeat within the building;
* a house has exactly one plot of type `KITCHEN_GARDEN`;
* a house has no `GARDEN` or `POOL`;
* a castle has one plot each of `KITCHEN_GARDEN`, `GARDEN`, and `POOL`;
* every plot has `templateId`, `name`, `gardenNumber`, `gardenType`, and an image;
* plot `templateId` values do not repeat within the building;
* plot `gardenNumber` values do not repeat within the building;
* `gardenType` is correct: `KITCHEN_GARDEN` — vegetable garden, `GARDEN` — garden, `POOL` — pond;
* `cost` is chosen with the prices of other buildings in mind;
* temporary `sourceImageUrl` links are publicly accessible;
* game instance UUIDs and other user data are absent;
* all `sourceImageUrl` values are replaced with `imageKey` before publication.

