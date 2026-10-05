# Maintaining the Owl Game Catalog

This document is primarily intended for the repository owner and backend developers. Instructions for game content authors are in [`catalog/README.md`](catalog/README.md) and the `README.md` files for the corresponding categories.

The current catalog schema version is defined by the `CATALOG_SCHEMA_VERSION` constant in [`owl-catalog-tools`](https://github.com/anastas-makar/owl-catalog-tools). The catalog repository uses the pinned package version `v0.2.0`.

After the first production release, changes to the catalog structure, validation rules, and contributor requirements are recorded in [`catalog/CHANGELOG.md`](catalog/CHANGELOG.md).

## Catalog versions

The catalog has two distinct kinds of version.

### Release version

The release version describes a specific published build of the catalog content.

It is passed to the builder via:

```text
--version
```

The catalog locale is passed to the builder separately via:

```text
--locale
```

For this repository, the locale is always `en`. The locale in the production tag name
must match the locale passed to the builder.

For a production release, the version is taken from the Git tag name:

```text
catalog-en-v0.1.0
```

The `en` prefix is required for the English catalog. It distinguishes its releases from
releases of catalogs in other languages.

Changes to game content, such as adding new enemies, furniture, or quests, may result in a new release without changing the catalog schema.

### Schema version

`schemaVersion` describes the catalog format: the JSON structure, required fields, and rules with which the backend and client must be compatible.

The current schema version is defined directly in code:

```python
CATALOG_SCHEMA_VERSION = 1
```

Contributors do not pass `schemaVersion` on the command line or choose it themselves.

After the first production release, an incompatible format change requires all of the following at the same time:

* change `CATALOG_SCHEMA_VERSION`;
* update the import DTOs and related backend models;
* update the validator in `owl-catalog-tools` and release a new package tag;
* update the pinned `owl-catalog-tools` version in the workflow and local catalog instructions;
* update the Android client if necessary;
* update the documentation;
* describe the change in [`catalog/CHANGELOG.md`](catalog/CHANGELOG.md).

Minor documentation corrections, wording clarifications, and other changes that do not alter the catalog contract do not require a `schemaVersion` increment.

Before the first production release, intermediate format changes are included in the initial `schemaVersion = 1` and are not recorded separately in `catalog/CHANGELOG.md`.

## Branches and change workflow

The usual change workflow:

1. Create a working branch from `develop`.
2. The author opens a pull request targeting `develop`.
3. Temporary external `sourceImageUrl` links are allowed in `develop`.
4. Before merging `develop` into `main`, images are checked and transferred to the primary S3 storage.
5. All `sourceImageUrl` values are replaced with `imageKey` values.
6. A pull request or push to `main` undergoes strict validation with
   `--require-image-keys` and `--validate-s3-images`.
7. A release tag `catalog-en-vX.Y.Z` is created only on a commit that belongs to `main`.
8. The workflow builds and publishes the final `catalog-release.json`.

Example working branch:

```bash
git checkout develop
git pull --ff-only origin develop

git checkout -b catalog/add-stone-fortress
```

## Building and validation

Run all commands below from the repository root.

Local validation requires Python 3.11 or later and Git. Install
the `owl-catalog-tools` version pinned for this repository:

```bash
python -m pip install "git+https://github.com/anastas-makar/owl-catalog-tools.git@v0.2.0"
```

Reinstallation is needed only when the pinned tool version changes.

### Regular validation for `develop`

This validation allows temporary `sourceImageUrl` values.

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

### Strict validation before `main` and release

Strict validation requires all images to already use `imageKey`.
It checks that every object exists in the primary S3 storage, its MIME type, and
that furniture image proportions match the `width` and `height` fields. The allowed
aspect ratio deviation is 5%.

On Windows:

```bat
.\scripts\validate-catalog-strict.bat
```

On Linux:

```bash
sh ./scripts/validate-catalog-strict.sh
```

If `validate-catalog-strict.sh` is executable:

```bash
./scripts/validate-catalog-strict.sh
```

Both options use the current schema version from `CATALOG_SCHEMA_VERSION`; there is no need to pass `schemaVersion` manually.

Strict validation accesses the public address
`https://s3.regru.cloud/owlgame/`, so it requires internet access.
Regular develop validation remains local and does not check S3 content.

The generated `build/catalog-release.json` is not edited manually.

## Images

The catalog supports two fields, used at different stages.

### sourceImageUrl

A temporary public link to the pull request author's image:

```json
{
  "sourceImageUrl": "https://example.org/generated/castle.png"
}
```

This field is allowed in a working branch and in `develop`. The author does not need access to the primary S3 storage.

Before using an image, manually check:

* that the link opens without authentication;
* that the file is actually an image;
* that the author has the right to contribute it to the project;
* that the image matches the entity's content;
* that it contains no accidental text, watermarks, or unwanted details;
* that its size and format suit the mobile app.

After files are transferred, strict validation automatically confirms that
each `imageKey` exists in the primary S3 storage and the server returns the expected
MIME type (`image/png`, `image/webp`, and so on). This does not replace a visual
inspection of the image.

Do not automatically download arbitrary links from external pull requests using production secrets.

### imageKey

A permanent object key in the primary S3 storage:

```json
{
  "imageKey": "buildings/stone-fortress.webp"
}
```

Only `imageKey` should be stored in `main`, the release tag, and the MongoDB catalog. The backend constructs the full public URL from the storage base address and the object key.

An object cannot specify both `sourceImageUrl` and `imageKey` at the same time.

The `imageUrl` field is not used in the source catalog. It may appear only in the API response prepared by the backend for the client.

## Identifiers

### Root templates

Each root entity has a `templateId` unique within its category:

```json
{
  "templateId": "stone-fortress"
}
```

`templateId`:

* written in kebab-case;
* remains stable after publication;
* contains no release number, environment, or user UUID;
* is not renamed after publication without a deliberate migration.

### Nested elements

Nested elements use the identifier specified by the model:

|Parent|Field|Identifier|
|-|-|-|
|building|`rooms`|`templateId`|
|building|`gardens`|`templateId`|
|location|`scenes`|`templateId`|
|map|`locationSlots`|`slotId`|
|map|`enemySlots`|`slotId`|
|quest|`pages`|`number`|
|quest ending|final page|`endingId`|

A nested identifier must be stable and unique within its parent. Preserving it distinguishes editing an existing element from deleting an old one and adding a new one.

### Player instances

UUIDs of player buildings, rooms, and other objects do not belong to the catalog. A player may have multiple instances of the same `templateId`, each with its own UUID.

## Acquisition sources

Entities that can be granted may have the optional `allowedAcquisitionSources` field.

An absent field or `null` means there are no restrictions:

```json
{
  "templateId": "wooden-chair"
}
```

An allowlist restricts acquisition methods:

```json
{
  "templateId": "quest-sword",
  "allowedAcquisitionSources": [
    "QUEST_REWARD"
  ]
}
```

An empty list means the entity cannot be obtained through any standard source:

```json
{
  "templateId": "unfinished-statue",
  "allowedAcquisitionSources": []
}
```

Values must match the current backend enum. When a new source is added, ordinary entities without an allowlist are automatically considered available through it.

## Localization

The current catalog is in English, and its locale is `en`. The locale is a property
of the entire catalog. User-facing fields contain plain English strings:

```json
{
  "name": "Stone Castle"
}
```

Catalogs in other languages are maintained and published separately with their own locale.
Do not add structures of the following form to user-facing fields:
`{"ru": "...", "en": "..."}`.

## Tags

Tags are added only to models that actually support them. Do not add `tags` to all entities in advance.

Technical tags should be written in lowercase Latin letters:

```json
{
  "tags": [
    "swamp",
    "undead"
  ]
}
```

New values must have clear game semantics and be used by a generator, filtering, or other code.

The `tags` field is required for pouch templates and cannot be empty. The tag selects the decorative set that the backend displays to the user. Ordinary pouches use:

```json
{
  "tags": [
    "default"
  ]
}
```

Seasonal variants may have separate tags, such as `new_year`. Adding a new tag requires configuration or code that actually activates the corresponding set.

The active set is selected by the `game.pouches.active-tag` property in `application.properties`. In production, its value is intended to be passed through the `GAME_POUCHES_ACTIVE_TAG` environment variable; the default value is `default`.

A pouch tag is not `allowedAcquisitionSources`: the pouch itself is not granted to the player or stored as a game world object.

## Quest loot

Loot is stored on the quest's final page through `lootBundle`.

Each pool that is present is rolled independently:

* an absent pool means this category grants nothing;
* an absent `dropChance` means a guaranteed drop;
* `dropChance: 0.5` means a 50% chance;
* `templateIds: null` or an absent field means any allowed template in the category may be selected;
* a nonempty `templateIds` restricts selection to the listed templates;
* an empty `templateIds` is a catalog error;
* an absent `amount` is interpreted by the service as `1`, if this matches the current backend implementation.

Rewards must reference only existing templates available through `QUEST_REWARD`.

`lootAvailable` is not part of the catalog. It is the state of a particular player: whether they are currently entitled to claim the reward.

## Schema changes

Before the first production release and the arrival of users, the schema can be changed freely, including deleting the test database.

After publication, consider:

* compatibility with older clients;
* identifier stability;
* user instances that have already been created;
* MongoDB migrations;
* changing `CATALOG_SCHEMA_VERSION`;
* reimporting the release;
* the behavior of older quests and rewards already received.

Changes to DTOs, catalog models, the mapper, the validator in `owl-catalog-tools`, and documentation are made as one coordinated change.

If a change affects the JSON format, required fields, or other compatibility rules, decide whether it requires incrementing `CATALOG_SCHEMA_VERSION`.

After the first production release, record all significant changes to the catalog format and rules in the `Unreleased` section of [`catalog/CHANGELOG.md`](catalog/CHANGELOG.md). When a new schema version is released, move the accumulated entries to that version's section.

## Pull request review

Before merging, check:

* the JSON builds successfully;
* the filename matches the root `templateId`;
* references point to existing templates;
* enum values exist in the backend;
* nested identifiers are unique;
* `sourceImageUrl` is allowed only before `main`;
* all images have been transferred to S3 before `main`;
* new fields are supported by the import DTO, Mongo model, and mapper;
* the validator in `owl-catalog-tools` knows about new references and constraints;
* after the first production release, `CATALOG_SCHEMA_VERSION` is updated when the schema changes;
* after the first production release, significant format or rule changes are recorded in `catalog/CHANGELOG.md`;
* the documentation for the relevant category is updated.

## Releasing

A release is created from a validated state of `main`:

```bash
git checkout main
git pull --ff-only origin main

git tag -a catalog-en-v0.1.0 -m "English catalog release 0.1.0"
git push origin catalog-en-v0.1.0
```

The tag name becomes the `version` of the published `catalog-release.json`.

`schemaVersion` is taken from `CATALOG_SCHEMA_VERSION` and does not depend on the release tag number.

For example, releases `catalog-en-v0.1.0`, `catalog-en-v0.1.1`, and `catalog-en-v0.2.0` may use the same schema version if the catalog format has not changed between them.

A published tag is never moved. A fix is released as a new commit and a new tag, such as `catalog-en-v0.1.1`.

