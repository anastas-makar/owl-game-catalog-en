# Garden and pond items

Each JSON file describes one item template used in the garden mechanic. In the game, these items are also called "garden finds".

This category includes various entities that the player can place in a garden or pond: trees, aquatic plants, fish, bird nests, beehives, animal houses, mushrooms, and other similar objects.

Garden and pond items are used to obtain supplies, like plants, but work slightly differently.

Plants are grown in a vegetable garden. Every house and castle has a vegetable garden.

Items from `garden-items` are placed only in a garden or pond. A castle has a garden and pond, but an ordinary house does not.

For details on houses, castles, gardens, and vegetable gardens, see [`../buildings/README.md`](../buildings/README.md).

After placement, the item periodically yields a particular supply. For example, an apple tree may produce apples, a beehive may produce honey, and a fish may produce chilled fish.

Unlike plants, garden and pond items do not disappear after supplies are collected and do not produce seeds. They therefore cannot be propagated by growing them.

The player chooses a place for each item in the appropriate garden or pond. This mechanic has no slots equivalent to map `locationSlots`.

Placing garden and pond items is free. No price is specified in the template.

General catalog guidelines are in [`catalog/README.md`](../README.md).

## Complete example

```json
{
  "templateId": "apple-tree",
  "name": "Apple Tree",
  "description": "An apple tree that regularly yields a harvest.",
  "sourceImageUrl": "https://example.org/apple-tree.png",
  "supplyTemplateId": "apple",
  "supplyAmount": 3,
  "itemType": "TREE",
  "gardenType": "GARDEN",
  "allowedAcquisitionSources": [
    "POUCH",
    "SHOP"
  ]
}
```

In a working branch, a temporary public `sourceImageUrl` can be used instead of `imageKey`, according to the general image guidelines.

Before publishing the catalog, temporary links are replaced with `imageKey` values.

## Garden or pond item template fields

### `templateId`

The required stable identifier of the item template.

```json
{
  "templateId": "apple-tree"
}
```

`templateId`:

* must be a nonempty string;
* must be unique among all garden and pond items;
* is preserved when editing an existing item.

Changing `templateId` means deleting the old template and adding a new one.

### `name`

The required item name displayed to the player.

```json
{
  "name": "Apple Tree"
}
```

### `description`

The required item description.

```json
{
  "description": "An apple tree that regularly yields a harvest."
}
```

### Image

The item must have an image.

In a working branch, the following is allowed:

```json
{
  "sourceImageUrl": "https://example.org/apple-tree.png"
}
```

The published catalog uses:

```json
{
  "imageKey": "garden-items/apple-tree.webp"
}
```

Do not specify `imageKey` and `sourceImageUrl` at the same time.

## Produced supply

Each garden or pond item produces one type of supply.

The `supplyTemplateId` field specifies which supply is obtained when collecting:

```json
{
  "supplyTemplateId": "apple"
}
```

The value must match the `templateId` of an existing supply in [`../supplies/`](../supplies/).

The `supplyAmount` field specifies the number of supply units obtained per collection:

```json
{
  "supplyAmount": 3
}
```

`supplyAmount` must be a positive integer.

The item does not disappear after collection and can later yield the same supply again.

Unlike plants, garden and pond items do not produce seeds.

## Placement area

The `gardenType` field determines where the player can place the item.

```json
{
  "gardenType": "GARDEN"
}
```

Two values are allowed for items from `garden-items`:

* `GARDEN` — a garden;
* `POOL` — a pond.

The general `GardenType` also includes `KITCHEN_GARDEN`. It denotes a vegetable garden and is used for plants. `KITCHEN_GARDEN` is not allowed for items from `garden-items`.

Items are placed by the player. Gardens and ponds have no predefined slots.

## Item type

The `itemType` field specifies the item's technical type.

```json
{
  "itemType": "TREE"
}
```

Allowed values:

* `TREE` — a tree;
* `FISH` — a fish;
* `WATER_PLANT` — an aquatic plant;
* `HIVE` — a beehive;
* `ANIMAL_HOUSE` — an animal house;
* `NEST` — a nest;
* `MUSHROOM` — a mushroom.

This is not a strict semantic classification. `itemType` must be one of the values listed above, but it is used primarily by the mobile app for technical purposes, particularly choosing the item icon.

The type therefore does not have to describe the item literally and exhaustively. Choose the most suitable option based on the icon that should be used in the interface.

`itemType` and `gardenType` have different meanings:

* `itemType` determines the item's type and display;
* `gardenType` determines where the item can be placed.

For example:

```json
{
  "itemType": "FISH",
  "gardenType": "POOL"
}
```

or:

```json
{
  "itemType": "TREE",
  "gardenType": "GARDEN"
}
```

## Acquisition sources

Standard item acquisition methods can be restricted through `allowedAcquisitionSources`.

For example, if the item can be obtained only as a quest reward:

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

* `templateId` is specified and unique among garden and pond items;
* `name` and `description` are specified;
* the image is provided through `sourceImageUrl` or `imageKey`;
* `supplyTemplateId` is specified and references an existing supply;
* `supplyAmount` is a positive integer;
* `itemType` matches one of the allowed item types;
* `gardenType` is `GARDEN` or `POOL`;
* `KITCHEN_GARDEN` is not used for items from `garden-items`;
* `allowedAcquisitionSources` values, if specified, are valid acquisition sources;
* temporary `sourceImageUrl` values are replaced with `imageKey` before publication.
