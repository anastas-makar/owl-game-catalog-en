# How to add game entities

This directory contains the source JSON files for the game catalog.

## Usual workflow

1. Find the directory for the relevant category.
2. Read its `README.md`.
3. Copy the existing JSON file closest in meaning.
4. Change `templateId`, display data, and references.
5. Run validation.
6. Open a pull request targeting `develop`.

Game content authors do not need access to `main`, the production server, or the primary S3 storage.

## Structure

```text
catalog/
  animals/
  buildings/
  enemies/
  furniture/
  garden-items/
  locations/
  maps/
  medals/
  plants/
  pouches/
  quests/
  recipes/
  supplies/
```

One source file contains one root template.

Pouches are an exception in meaning only, not in storage format: each JSON file in `pouches/` describes one decorative image template. Pouch templates are not game world objects.

```text
buildings/stone-fortress.json
furniture/red-sofa.json
quests/first-hatches.json
```

The filename must match the root `templateId`.

## General JSON requirements

The file must:

* contain one JSON object at the root;
* use UTF-8;
* use double quotes;
* contain no comments or trailing commas;
* have a root `templateId`;
* contain no `id`, `releaseId`, or user object UUIDs.

Correct:

```json
{
  "templateId": "red-sofa",
  "name": "Red Sofa"
}
```

Incorrect:

```json
{
  "templateId": "Red_Sofa_v2",
  "id": "0f88d63c-...",
  "releaseId": "..."
}
```

## Identifiers

Root `templateId` values are written in kebab-case:

```text
stone-fortress
swamp-ghoul
red-sofa
```

After publication, the identifier is preserved even if the object's name changes.

Nested elements may use `templateId`, `slotId`, `endingId`, or a page number. Use the field specified by the model for the relevant category.

## Text

The current catalog is in English. Names, descriptions, and button text are written in English.

Technical identifiers, enum values, and tags use the format specified in the documentation for the relevant category.

## Images

Do not add an image directly to Git.

If the image is already in the primary storage, specify:

```json
{
  "imageKey": "furniture/red-sofa.webp"
}
```

If you do not have access to the storage, provide a temporary public link:

```json
{
  "sourceImageUrl": "https://example.org/my-red-sofa.png"
}
```

Before merging changes into `main`, the project maintainer will check the image, upload it to the primary S3 storage, and replace `sourceImageUrl` with `imageKey`.

Do not specify both fields at the same time. Do not use `imageUrl` in the source catalog.

<a id="acquisition-sources"></a>

## Acquisition sources

Entities that can be granted to players may have an `allowedAcquisitionSources` field.

This is an allowlist of ways to obtain the entity:

```json
{
  "allowedAcquisitionSources": [
    "POUCH",
    "SHOP"
  ]
}
```

The field has the following semantics:

* if the field is absent or `null`, there are no restrictions: the entity can be obtained through any supported method;
* if an empty list is specified, the entity cannot be obtained through any standard method;
* if a nonempty list is specified, the entity can be obtained only through the listed methods.

Available sources:

* `POUCH` — the entity may drop randomly from a pouch;
* `SHOP` — the entity may appear in the merchant's shop;
* `QUEST_REWARD` — the entity may be granted as a reward for completing a quest;
* `EXPEDITION_REWARD` — the entity may be granted after winning an expedition and liberating a map.

Example of an ordinary entity without restrictions:

```json
{
  "templateId": "pumpkin-soup"
}
```

Example of a recipe that can be found only in a pouch or the shop:

```json
{
  "templateId": "pumpkin-soup",
  "allowedAcquisitionSources": [
    "POUCH",
    "SHOP"
  ]
}
```

Example of an entity available only as a quest reward:

```json
{
  "templateId": "ancient-potion",
  "allowedAcquisitionSources": [
    "QUEST_REWARD"
  ]
}
```

Example of an entity not currently granted to players through standard methods:

```json
{
  "templateId": "unfinished-recipe",
  "allowedAcquisitionSources": []
}
```

When a new source is added, ordinary entities without `allowedAcquisitionSources` are automatically considered available through it. Entities with an explicit allowlist remain available only through the listed sources.

Quest rewards are described in the `lootBundle` on the quest's final page. For details, see the [quest documentation](quests/README.md#loot).

Most entities can be obtained through any method, so the restriction field is usually unnecessary.



## References between entities

Fields such as:

```text
questTemplateId
supplyTemplateId
fixedLocationTemplateId
completionMedalTemplateId
```

must reference an existing `templateId` in the appropriate category.

## Validation

Run validation from the repository root.

Validation requires Python 3.11 or later, Git, and the package
[`owl-catalog-tools`](https://github.com/anastas-makar/owl-catalog-tools).
Install the package version pinned for this catalog:

```bash
python -m pip install "git+https://github.com/anastas-makar/owl-catalog-tools.git@v0.2.0"
```

There is no need to reinstall the package before each validation.

On Windows:

```bat
.\scripts\validate-catalog.bat
```

On Linux:

```bash
sh ./scripts/validate-catalog.sh
```

If `validate-catalog.sh` is executable:

```bash
./scripts/validate-catalog.sh
```

This validation corresponds to working with `develop` and allows temporary `sourceImageUrl` values.

Strict validation before `main` is performed by the project maintainer. It also
checks that each `imageKey` exists in the primary S3 storage and has the correct
MIME type. For furniture, it also compares the image file proportions
with the `width / height` ratio in the catalog.

## Category instructions

* [Buildings](buildings/README.md)
* [Enemies](enemies/README.md)
* [Furniture](furniture/README.md)
* [Garden items](garden-items/README.md)
* [Locations](locations/README.md)
* [Maps](maps/README.md)
* [Medals](medals/README.md)
* [Plants](plants/README.md)
* [Quests](quests/README.md)
* [Recipes](recipes/README.md)
* [Supplies](supplies/README.md)

### Pouches

Pouch templates are not part of the game world, and there is usually no need to increase their number:

* [Pouches](pouches/README.md)

## Catalog format version

Current catalog schema version: **1**.

The schema version changes when the JSON structure, required fields, or data processing rules change in a way
that requires changes to existing catalog files, the backend, or the client.

The change history is in [`CHANGELOG.md`](CHANGELOG.md).

