# Owl Game Catalog (English)

This repository, [`owl-game-catalog-en`](https://github.com/anastas-makar/owl-game-catalog-en), contains the source data for the English Owl Game catalog.

The catalog is stored as separate JSON files. The [`owl-catalog-tools`](https://github.com/anastas-makar/owl-catalog-tools) package validates them and combines them into a single `catalog-release.json`, which is then imported by the backend.

## For game content authors

1. Create a branch from `develop`.

2. Add or edit JSON files inside `catalog/`.

3. Do not add images directly to the Git repository.

4. If an image is not yet in the primary storage, specify a temporary public `sourceImageUrl`.

5. Install the validation tool (required only for initial setup or when updating its version):

   ```bash
   python -m pip install "git+https://github.com/anastas-makar/owl-catalog-tools.git@v0.2.0"
   ```

   Validation requires Python 3.11 or later and Git.

6. Run local catalog validation.

   On Windows, run from the repository root:

   ```bat
   .\scripts\validate-catalog.bat
   ```

   On Linux, run:

   ```bash
   sh ./scripts/validate-catalog.sh
   ```

   If `validate-catalog.sh` is executable, you can also run it directly:

   ```bash
   ./scripts/validate-catalog.sh
   ```

   If validation succeeds, the final output will be:

   ```text
   Catalog validation OK
   ```

7. Open a pull request targeting `develop`.

Start with the [general instructions for catalog authors](catalog/README.md), then read `README.md` in the relevant directory:

* [animals](catalog/animals/README.md);
* [buildings](catalog/buildings/README.md);
* [enemies](catalog/enemies/README.md);
* [furniture](catalog/furniture/README.md);
* [garden items](catalog/garden-items/README.md);
* [locations](catalog/locations/README.md);
* [maps](catalog/maps/README.md);
* [medals](catalog/medals/README.md);
* [plants](catalog/plants/README.md);
* [quests](catalog/quests/README.md);
* [recipes](catalog/recipes/README.md);
* [supplies](catalog/supplies/README.md).

Pouches are a special category. Do not add more, since the game does not need a large number of pouches:

* [pouches](catalog/pouches/README.md);

## For repository maintainers

Rules for validation, transferring images to S3, merging into `main`, and publishing releases are described in [CONTRIBUTING.md](CONTRIBUTING.md).

## What not to commit

Do not add the following to the repository:

* images and other large binary files;
* a manually built `catalog-release.json`;
* MongoDB fields `id` and `releaseId`;
* UUIDs of specific user game objects;
* secrets, access keys, or internal service addresses.

