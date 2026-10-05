# Recipes

Each file describes one recipe, its result, and the required ingredients.

Keep recipes simple: ingredients are found with a certain probability, so a long component list will be difficult to collect.

A recipe should usually have no more than two ingredients. In exceptional cases, three ingredients are allowed.

It is better to omit basics such as water, salt, and frying oil. The player is assumed to always have them in the required quantities.

Using supplies that are themselves made from recipes as ingredients is not recommended. A few predefined basic ingredients are exceptions.

General guidelines are in [`catalog/README.md`](../README.md).

## Basic compound ingredients

Some supplies are made from recipes but can then be used in other recipes.

In particular, they are needed to make potions that deal damage:

* Chilling Tincture;
* Scorching Tincture;
* Powerful Bomb.

This list is not yet final. Before adding a new compound ingredient, check whether it is actually needed by several recipes. Avoid long chains where making one item first requires making several others.

## Structure example

```json
{
  "templateId": "pumpkin-soup",
  "name": "Pumpkin Soup",
  "description": "Requires pumpkin and milk.",
  "resultSupplyTemplateId": "pumpkin-soup-supply",
  "ingredients": [
    {
      "supplyTemplateId": "pumpkin",
      "amount": 2
    },
    {
      "supplyTemplateId": "milk",
      "amount": 1
    }
  ]
}
```

Fields must follow the structure shown in the example above.

## Result

`resultSupplyTemplateId` must reference an existing supply
in [`../supplies/`](../supplies/).

A recipe always yields one type of supply. The quantity of the resulting supply is always 1.

## Ingredients

Each ingredient must reference an existing `supplyTemplateId`.

`amount` must be a positive integer.

Do not accidentally add the same supply to the ingredient list several times:

```json
{
  "ingredients": [
    {
      "supplyTemplateId": "pumpkin",
      "amount": 1
    },
    {
      "supplyTemplateId": "pumpkin",
      "amount": 1
    }
  ]
}
```

Instead, combine the quantities:

```json
{
  "ingredients": [
    {
      "supplyTemplateId": "pumpkin",
      "amount": 2
    }
  ]
}
```

## Acquisition sources

Recipes may drop from a pouch, appear in the merchant's shop, or be granted for completing a quest or expedition.

If a recipe can be obtained through any method, there is no need to specify `allowedAcquisitionSources`.

Example of a recipe available only in pouches and the shop:

```json
{
  "templateId": "pumpkin-soup",
  "allowedAcquisitionSources": [
    "POUCH",
    "SHOP"
  ]
}
```

For details on the allowlist, see the
["Acquisition sources" section](../README.md#acquisition-sources).

## Granting a recipe for a quest

To grant a particular recipe for completing a quest, specify its `templateId` in `recipeLoot` on the final page:

```json
{
  "endingId": "cookbook-found",
  "lootButtonText": "Take the recipe",
  "lootBundle": {
    "recipeLoot": {
      "templateIds": [
        "pumpkin-soup"
      ],
      "amount": 1
    }
  }
}
```

If a recipe has an `allowedAcquisitionSources` allowlist, it must contain `QUEST_REWARD`.

## Validation

Before opening a pull request, check:

* the recipe's `templateId` is unique;
* `resultSupplyTemplateId` references an existing supply;
* all ingredients exist;
* the `ingredients` list is not empty;
* each ingredient's `amount` is a positive integer;
* no ingredient is listed several times;
* the recipe contains no unnecessary basic components;
* the recipe usually requires no more than two ingredients, or three in an exceptional case;
* compound ingredients are used only when necessary;
* `allowedAcquisitionSources` values exist in the backend enum.
