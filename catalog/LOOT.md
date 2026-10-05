# Loot

`lootBundle` describes a set of possible rewards.

The same structure is used in different gameplay situations, for example:

* as a reward for a quest ending;
* as a reward for winning an expedition and liberating a map.

The specific acquisition source is determined by where `lootBundle` is used:

* quest — `QUEST_REWARD`;
* expedition — `EXPEDITION_REWARD`.

Restrictions on how the entities themselves can be obtained are described in the ["Acquisition sources" section](README.md#acquisition-sources).

## Structure

`lootBundle` may contain the following pools:

```text
buildingLoot
mapLoot
diamondLoot
gardenItemLoot
plantLoot
furnitureLoot
recipeLoot
locationLoot
```

Each pool is rolled independently of the others.

For example:

```json
{
  "lootBundle": {
    "furnitureLoot": {
      "templateIds": [
        "red-sofa",
        "green-armchair",
        "old-table"
      ],
      "amount": 2,
      "dropChance": 0.25
    },
    "plantLoot": {
      "amount": 1,
      "dropChance": 0.5
    },
    "diamondLoot": {
      "amount": 20
    }
  }
}
```

This example means:

* with a 25% chance, two different furniture items will be selected from the three listed;
* independently, with a 50% chance, one eligible plant will be selected;
* regardless of the previous results, 20 diamonds are guaranteed to be granted.

## Independent pools

Each pool that is present checks its own `dropChance` separately.

For example:

```json
{
  "buildingLoot": {
    "amount": 1,
    "dropChance": 0.5
  },
  "recipeLoot": {
    "amount": 1,
    "dropChance": 0.5
  }
}
```

Four outcomes are possible:

* both a building and a recipe drop;
* only a building drops;
* only a recipe drops;
* nothing drops.

The probability of one pool does not affect the probability of another.

## Ordinary pool

All pools except `diamondLoot` use the same structure:

```json
{
  "templateIds": [
    "red-sofa",
    "green-armchair",
    "old-table"
  ],
  "amount": 2,
  "dropChance": 0.5
}
```

Fields:

* `templateIds` — the set of templates to choose from;
* `amount` — the number of distinct templates to select;
* `dropChance` — the probability that the pool drops.

## `templateIds`

`templateIds` restricts the set of possible rewards.

```json
{
  "templateIds": [
    "red-sofa",
    "green-armchair",
    "old-table"
  ]
}
```

When a nonempty list is present, only the listed templates may be selected.

The number of templates actually selected is determined by `amount`.

### Selection without repetition

The same template is not selected twice within a pool.

For example:

```json
{
  "templateIds": [
    "red-sofa",
    "green-armchair",
    "old-table"
  ],
  "amount": 2
}
```

means selecting two distinct templates out of three.

Possible combinations include:

```text
red-sofa + green-armchair
red-sofa + old-table
green-armchair + old-table
```

The result:

```text
red-sofa + red-sofa
```

is impossible.

If:

```json
{
  "templateIds": [
    "red-sofa",
    "green-armchair",
    "old-table"
  ],
  "amount": 3
}
```

all three templates will be selected.

### `templateIds: null`

If `templateIds` is absent or `null`, selection is made from all templates in the corresponding category that may be obtained through the current method.

For example, in a quest:

```json
{
  "plantLoot": {
    "templateIds": null,
    "amount": 2
  }
}
```

means selecting two distinct plants from all plants available through `QUEST_REWARD`.

For an expedition reward, the same pool would select plants available through `EXPEDITION_REWARD`.

### Empty list

An empty list is forbidden:

```json
{
  "templateIds": []
}
```

If no reward is needed, remove the entire corresponding pool.

## `amount`

For an ordinary pool, `amount` means the number of **distinct templates** to select.

For example:

```json
{
  "templateIds": [
    "recipe-a",
    "recipe-b",
    "recipe-c"
  ],
  "amount": 2
}
```

means: select two distinct recipes out of three and grant one instance of each selected recipe.

`amount` must be a positive integer.

If `amount` is absent or `null`, one template is selected.

`amount` cannot exceed the number of available candidates.

Therefore, this pool is invalid:

```json
{
  "templateIds": [
    "recipe-a",
    "recipe-b"
  ],
  "amount": 3
}
```

If `templateIds` is `null`, the number of all templates in the category allowed for the current acquisition source is considered.

For example, if only two recipes may be obtained through `QUEST_REWARD`, the value:

```json
{
  "recipeLoot": {
    "amount": 3
  }
}
```

is also invalid.

## `dropChance`

`dropChance` specifies the probability that the entire pool drops.

Its value ranges from `0` to `1`.

```json
{
  "dropChance": 0.5
}
```

means a 50% chance.

```json
{
  "dropChance": 0.1
}
```

means a 10% chance.

If `dropChance` is absent or `null`, the pool is guaranteed to drop.

```json
{
  "recipeLoot": {
    "amount": 1
  }
}
```

means one recipe is guaranteed to be granted.

`dropChance` is not a relative weight and does not determine the number of attempts.

The current model has no additional concepts such as `rolls` or `withReplacement`.

## Diamonds

`diamondLoot` differs from the other pools because diamonds have no `templateId`.

```json
{
  "diamondLoot": {
    "amount": 20,
    "dropChance": 0.5
  }
}
```

Fields:

* `amount` — the number of diamonds;
* `dropChance` — the probability of receiving them.

For diamonds, `amount` is required and must be a positive integer.

If `dropChance` is absent or `null`, diamonds are guaranteed to be granted.

Example of a guaranteed reward:

```json
{
  "diamondLoot": {
    "amount": 50
  }
}
```

## Acquisition sources

Each `lootBundle` is rolled in the context of a specific source.

Quest:

```text
QUEST_REWARD
```

Expedition:

```text
EXPEDITION_REWARD
```

If an entity has no `allowedAcquisitionSources` or the field is `null`, there are no restrictions and it may participate in any such pool.

For example:

```json
{
  "templateId": "pumpkin-soup"
}
```

may be selected by both a quest and an expedition.

If an allowlist is specified:

```json
{
  "templateId": "secret-recipe",
  "allowedAcquisitionSources": [
    "QUEST_REWARD"
  ]
}
```

this recipe may be granted through a quest but not as an expedition reward.

To allow both methods:

```json
{
  "templateId": "secret-recipe",
  "allowedAcquisitionSources": [
    "QUEST_REWARD",
    "EXPEDITION_REWARD"
  ]
}
```

An empty `allowedAcquisitionSources` means the entity cannot be obtained through any standard method:

```json
{
  "allowedAcquisitionSources": []
}
```

For details, see the ["Acquisition sources" section](README.md#acquisition-sources).

## Complete `lootBundle` example

```json
{
  "lootBundle": {
    "buildingLoot": {
      "templateIds": [
        "small-stone-house",
        "wooden-house",
        "swamp-hut"
      ],
      "amount": 2,
      "dropChance": 0.1
    },
    "mapLoot": {
      "templateIds": [
        "old-forest-map",
        "swamp-map"
      ],
      "amount": 1,
      "dropChance": 0.2
    },
    "diamondLoot": {
      "amount": 20
    },
    "gardenItemLoot": {
      "templateIds": [
        "old-watering-can",
        "wooden-planter"
      ],
      "amount": 1,
      "dropChance": 0.3
    },
    "plantLoot": {
      "templateIds": null,
      "amount": 2,
      "dropChance": 0.5
    },
    "furnitureLoot": {
      "templateIds": [
        "red-sofa",
        "green-armchair",
        "old-table"
      ],
      "amount": 2,
      "dropChance": 0.25
    },
    "recipeLoot": {
      "templateIds": [
        "pumpkin-soup",
        "healing-potion"
      ],
      "amount": 1,
      "dropChance": 0.5
    },
    "locationLoot": {
      "templateIds": [
        "old-grotto"
      ],
      "amount": 1,
      "dropChance": 0.1
    }
  }
}
```

There is no need to list all categories. Usually, `lootBundle` should contain only the pools actually needed for this reward.

## Validation

The following rules must hold for every `lootBundle`:

* `lootBundle` contains at least one pool;
* `templateIds` is absent, `null`, or a nonempty list;
* all listed `templateIds` exist in the corresponding category;
* no `templateId` repeats within a pool;
* each selected template may be obtained through the current source;
* an ordinary pool's `amount` is a positive integer;
* `amount` does not exceed the number of available candidates;
* `dropChance` ranges from `0` to `1`;
* `amount` for `diamondLoot` is a positive integer;
* each pool that is present is rolled independently of the others.
