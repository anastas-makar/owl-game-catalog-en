# Quests

A quest consists of pages.

Each page may have text and an image. If the quest continues, the page contains action options leading to subsequent pages.

A quest is launched from a location scene that references it through `questTemplateId`. For details, see the [location documentation](../locations/README.md).

The final page has no continuation options and has a stable `endingId`.

An ending may also:

* change the location scene through `scenePatch`;
* grant a reward through `lootBundle`.

General guidelines are in [`catalog/README.md`](../README.md).

## Complete example

Below is an example quest using all model fields.

```json
{
  "templateId": "first-hatches",
  "title": "The First Hatches",
  "startPageNumber": 1,
  "pages": [
    {
      "number": 1,
      "name": "Closed Hatch",
      "description": "An old iron hatch stands before you. Cold air seeps from beneath its lid.",
      "imageKey": "quests/first-hatches/closed-hatch.webp",
      "options": [
        {
          "description": "Open the hatch",
          "targetPageNumber": 2
        },
        {
          "description": "Leave the hatch alone",
          "targetPageNumber": 3
        }
      ]
    },
    {
      "number": 2,
      "name": "Dungeon",
      "description": "An old underground hall is revealed beneath the hatch. A dust-covered chest stands in the corner.",
      "imageKey": "quests/first-hatches/underground-hall.webp",
      "options": [],
      "endingId": "hatch-opened",
      "scenePatch": {
        "description": "The old iron hatch is now open. A descent into the dungeon is visible beneath it.",
        "imageKey": "locations/old-grotto/open-hatch.webp"
      },
      "lootButtonText": "Take what you found",
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
          "amount": 20,
          "dropChance": 1.0
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
    },
    {
      "number": 3,
      "name": "Return",
      "description": "You decide to leave the hatch closed for now and return to it later.",
      "imageKey": "quests/first-hatches/leave-hatch.webp",
      "options": [],
      "endingId": "left-the-hatch",
      "scenePatch": {
        "description": "The old iron hatch is still closed.",
        "imageKey": "locations/old-grotto/closed-hatch.webp"
      }
    }
  ]
}
```

In a working branch, a temporary `sourceImageUrl` can be used instead of `imageKey`, according to the [general image guidelines](../README.md). Before the catalog reaches `main`, temporary links are replaced with `imageKey` values.

## Start page

`startPageNumber` specifies the page number where the quest begins.

It must match the `number` of one of the pages:

```json
{
  "startPageNumber": 1
}
```

## Page numbers

`number`:

* is required for each page;
* is an integer;
* is unique within the quest;
* is used in `startPageNumber` and `targetPageNumber`;
* is not a UUID;
* must not be changed accidentally when editing an existing page.

The order of pages in JSON is not used instead of `number`.

## Transitions

If the quest continues, the page contains `options`.

Each option consists of action text and the next page number:

```json
{
  "description": "Continue",
  "targetPageNumber": 4
}
```

`targetPageNumber` must point to an existing page in the same quest.

Example of a branch:

```json
{
  "number": 1,
  "name": "Fork in the Path",
  "description": "The path splits in two.",
  "options": [
    {
      "description": "Go left",
      "targetPageNumber": 2
    },
    {
      "description": "Go right",
      "targetPageNumber": 3
    }
  ]
}
```

## Final pages and `endingId`

A final page ends the quest and has no continuation options.

It has a stable `endingId`:

```json
{
  "number": 7,
  "name": "Rescue",
  "description": "The owl is rescued.",
  "options": [],
  "endingId": "owl-rescued"
}
```

`endingId`:

* must be a nonempty string;
* is unique within the quest;
* is preserved when editing an existing ending.

A new `endingId` means a new ending.

The backend also uses `endingId` to distinguish endings and their associated actions, particularly claiming rewards.

## Page images

A page may contain its own image:

```json
{
  "imageKey": "quests/first-hatches/underground-hall.webp"
}
```

In the author's working branch, a temporary `sourceImageUrl` is allowed instead of `imageKey`.

Do not specify `imageKey` and `sourceImageUrl` at the same time.

## `scenePatch`

`scenePatch` describes the change to a location scene caused by a particular quest ending.

For example, a hatch may be closed before the quest and open after one of its endings.

```json
{
  "endingId": "hatch-opened",
  "scenePatch": {
    "description": "The old hatch is open. A staircase leading down is visible beneath it.",
    "imageKey": "locations/old-grotto/open-hatch.webp"
  }
}
```

`scenePatch` can change:

* `description` — the scene description;
* `imageKey` — the scene image.

In the author's working branch, a temporary `sourceImageUrl` can be used instead of `imageKey`.

`scenePatch` applies to the location scene from which the quest was launched, not to the quest page itself.

## Loot

A final page with `endingId` may contain `lootBundle`.

```json
{
  "endingId": "hatch-opened",
  "lootButtonText": "Claim the reward",
  "lootBundle": {
    "recipeLoot": {
      "templateIds": [
        "pumpkin-soup",
        "healing-potion"
      ],
      "amount": 1,
      "dropChance": 0.5
    },
    "diamondLoot": {
      "amount": 20
    }
  }
}
```

For a quest `lootBundle`, the acquisition source is `QUEST_REWARD`.

If a reward has `allowedAcquisitionSources`, its allowlist must permit `QUEST_REWARD`.

The `lootBundle` structure and the rules for `templateIds`, `amount`, `dropChance`, and selection without repetition are described in detail in the [loot documentation](../LOOT.md).

## Reward button

`lootButtonText` specifies the text of the button through which the player claims the reward:

```json
{
  "lootButtonText": "Claim the reward"
}
```

`lootButtonText` is used only together with `lootBundle`.

The `lootAvailable` field is absent from the catalog. Reward availability is the state of a particular player and is determined by the backend.

## Quest validation

Before opening a pull request, check:

* the quest's `templateId` is unique;
* `startPageNumber` points to an existing page;
* page numbers are integers and do not repeat;
* all `targetPageNumber` values point to existing pages;
* all `endingId` values are unique within the quest;
* final pages have no continuation options;
* all pages are reachable from `startPageNumber`;
* each nonfinal page has at least one continuation option;
* from every reachable page, there is a path to at least one final page.
* `lootBundle` is present only on a page with `endingId`;
* `lootButtonText` does not exist without `lootBundle`;
* `lootBundle` content follows the [loot rules](../LOOT.md);
* rewards in `lootBundle` may be obtained through `QUEST_REWARD`;
* temporary image links open without authentication;
* temporary `sourceImageUrl` values are replaced with `imageKey` before changes reach `main`.
