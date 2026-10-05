# Furniture

Each JSON file describes one furniture item template.

Furniture can be placed in the rooms of houses and castles.

The player must first obtain a furniture item through one of the available methods, then place it in a room. When placing it, the player pays the number of diamonds specified in `price`.

Thus, `allowedAcquisitionSources` determines how furniture is obtained, while `price` determines its placement cost. These are separate mechanics.

A refrigerator is a special furniture type. If a room has a refrigerator and an animal lives in the house or castle, cooking is available in that room.

For details on cooking with recipes, see [`../recipes/README.md`](../recipes/README.md).

## Furniture dimensions

Furniture dimensions are specified relative to the width of an ideal square room.

The width of that room is taken as `1`.

For example:

```json
{
  "width": 0.42,
  "height": 0.28
}
```

means the item occupies approximately 42% of the room's width and 28% of its height.

Furniture dimensions in the game are deliberately reduced compared with realistic proportions. This reflects both the size of the animal characters and the need to conveniently place several items in a two-dimensional room.

However, the `width / height` ratio must match the aspect ratio
of the image file itself. The item's scale in the room can be decreased or
increased, but it must not be stretched independently along one axis. Strict
validation allows a deviation of no more than 5%.

The dimensions of the entire file are checked, including transparent margins. Therefore, before
uploading to S3, crop furniture images to the proportions in which
they should appear in the game.

When adding a new item, compare its dimensions with similar furniture already in the catalog.

General catalog guidelines are in [`catalog/README.md`](../README.md).

## Complete example

```json
{
  "templateId": "red-sofa",
  "name": "Red Sofa",
  "sourceImageUrl": "https://example.org/red-sofa.png",
  "price": 350,
  "height": 0.28,
  "width": 0.42,
  "type": "OTHER",
  "allowedAcquisitionSources": [
    "POUCH",
    "SHOP"
  ]
}
```

In a working branch, a temporary public `sourceImageUrl` can be used instead of `imageKey`.

Before publishing the catalog, temporary links are replaced with `imageKey` values.

## Furniture fields

### `templateId`

The required stable identifier of the furniture template.

```json
{
  "templateId": "red-sofa"
}
```

`templateId`:

* must be a nonempty string;
* must be unique among all furniture templates;
* is preserved when editing an existing item.

Changing `templateId` means deleting the old template and adding a new one.

### `name`

The required item name displayed to the player.

```json
{
  "name": "Red Sofa"
}
```

### Image

Every furniture item must have an image.

In a working branch, the following is allowed:

```json
{
  "sourceImageUrl": "https://example.org/red-sofa.png"
}
```

The published catalog uses:

```json
{
  "imageKey": "furniture/red-sofa.webp"
}
```

Do not specify `imageKey` and `sourceImageUrl` at the same time.

## Price

The `price` field specifies the cost in diamonds of placing furniture in a room.

```json
{
  "price": 350
}
```

`price` must be a nonnegative integer.

A value of `0` means the item can be placed for free.

The placement price does not determine how furniture is obtained. Acquisition methods are defined separately through `allowedAcquisitionSources`.

## Size

The `width` and `height` fields specify the item's size in a room:

```json
{
  "width": 0.42,
  "height": 0.28
}
```

`width` and `height` must be numbers greater than 0 and no greater than 1.

The width of an ideal square room is taken as one unit.

Choose the overall scale relative to existing furniture. Do not
try to reproduce real item sizes literally: game
dimensions are specifically adapted for the interface and furniture placement in a room.
However, the `width / height` ratio must preserve the proportions of the image file,
so that the item is not stretched or compressed.

## Furniture type

The `type` field determines the item's technical type.

Allowed values:

* `REFRIGERATOR` — a refrigerator;
* `OTHER` — any other furniture.

For example:

```json
{
  "type": "REFRIGERATOR"
}
```

`REFRIGERATOR` has a special gameplay meaning: a refrigerator allows a room to be used for cooking if an animal lives in the house or castle.

For all furniture other than refrigerators, use:

```json
{
  "type": "OTHER"
}
```

Types such as `SOFA`, `TABLE`, `BED`, or `CHAIR` are not used in the catalog.

## Acquisition sources

Furniture acquisition methods can be restricted through `allowedAcquisitionSources`.

For example, furniture obtainable only as a quest reward:

```json
{
  "allowedAcquisitionSources": [
    "QUEST_REWARD"
  ]
}
```

An absent `allowedAcquisitionSources` or a value of `null` means there are no restrictions on standard acquisition sources.

An empty array:

```json
{
  "allowedAcquisitionSources": []
}
```

means the item cannot be obtained through any standard method.

General rules and the full source list are described in the ["Acquisition sources" section](../README.md#acquisition-sources).

## Validation

Before opening a pull request, check:

* `templateId` is specified and unique among furniture;
* `name` is specified;
* the image is provided through `sourceImageUrl` or `imageKey`;
* `price` is a nonnegative integer;
* `width` and `height` are numbers greater than `0` and no greater than `1`;
* `type` is `REFRIGERATOR` or `OTHER`;
* all ordinary furniture uses type `OTHER`;
* `allowedAcquisitionSources` values, if specified, are valid acquisition sources;
* temporary `sourceImageUrl` values are replaced with `imageKey` before publication.

