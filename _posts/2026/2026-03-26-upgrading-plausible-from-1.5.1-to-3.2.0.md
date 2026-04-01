---
title: Upgrading Plausible from 1.5.1 to 3.2.0
date: 2026-03-26
categories: [Technology & IT, Linux]
tags:
  - plausible
  - analytics
  - clickhouse
  - migration
  - postgres
---

I'm one of the (main) sysadmins of a forum running [phpBB](https://www.phpbb.com/). It also uses [Plausible](https://plausible.io/self-hosted-web-analytics), a self-hosted web analytics tool, so we have some grasp where our users come from.

My main focus is dealing with the underlying virtual hardware and OS - the forum software is updated by someone else, and Plausible was installed and then promptly forgotten about 3 years ago by yet another person.

While doing some maintenance work I asked the person who had installed if they were keeping it updated, to which the answer was *does it need updating?* ... so I decided to have a look.

There were a few issues with the way it was running

* Installed on the wrong server (we have a few)
* Running on a non-standard web port (can be blocked by certain firewalls)
* *very* old (version [1.5.1](https://github.com/plausible/analytics/releases/tag/v1.5.1))!

## Upgrading Plausible

Moving and upgrading Plausible seemed simple enough:

* Reinstalling it as per the [Getting Started instructions on the GitHub page](https://github.com/plausible/community-edition/)
* Exporting the Postgres database, and importing it
* Copying over the [Clickhouse](https://clickhouse.com/) database
* Executing a migration to the v2 schema (required for [Plausible 2.0.0](https://github.com/plausible/analytics/releases/tag/v2.0.0))
.. but I hit a few snags along the way.

### Reinstalling Plausible

This step is easy: just follow the [Getting Started instructions on the GitHub page](https://github.com/plausible/community-edition/) guide, adjusting where necessary.

### Exporting and Importing the Postgres database

This is documented on the [Plausible Wiki](https://github.com/plausible/community-edition/wiki/Upgrade-PostgreSQL), but you can find instructions on how to do this all over the web. Pretty standard `pg_dump` and `psql < file`.

On the old machine:

```shell
docker compose stop plausible
docker compose exec plausible_db sh -c "pg_dump -U postgres plausible_db > plausible_db.bak"
docker compose cp plausible_db:plausible_db.bak plausible_db.bak
```

Copy the `plausible_db.bak`{: .filepath } over to the new machine

On the new machine:

```shell
docker compose exec plausible_db createdb -U postgres plausible_db
docker compose cp plausible_db.bak plausible_db:plausible_db.bak
docker compose exec plausible_db sh -c "psql -U postgres -d plausible_db < plausible_db.bak"
docker compose up -d
```

### Copying the Clickhouse database

This one was slightly more involved - as there are actually two migrations that need to happen:

* upgrading Clickhouse from 22.6 to 24.12 (handled by Clickhouse itself)
* doing a migration from `event_v1` to `event_v2` tables for Plausible

I am not familiar with Clickhouse whatsoever, and the many paths I tried to take to export and import the data all ended in problems.
The final option - which worked - was to copy the actual container volume over - the one stored on the old server in `/var/lib/docker/volumes/hosting_event-data`{: .filepath } to the new machine under `/var/lib/docker/volumes/plausible_event-data`{: .filepath }.

> Remember to first **stop** the clickhouse event container before copying the files!
{: .prompt-warning }

After this I started the Plausible containers, and executed the migration:

```shell
docker compose exec plausible bin/plausible rpc Plausible.DataMigration.NumericIDs.run
```

This worked, but when testing my new Plausible install I kept getting weird errors and Plausible would crash:

```text
plausible-1  | ** (exit) an exception was raised:
plausible-1  |     ** (Ch.Error) Code: 47. DB::Exception: Identifier 's0.source' cannot be resolved from table with name s0. In scope SELECT toUInt64(round(uniq(s0.user_id) * any(_sample_factor))) AS visitors, if(empty(s0.source), 'Direct / None', s0.source) AS dim0 FROM sessions_v2 AS s0 WHERE (s0.site_id = _CAST(154, 'Int64')) AND (s0.start >= _CAST(1756929600, 'DateTime')) AND (s0.timestamp >= _CAST(1757534400, 'DateTime')) AND (s0.start <= _CAST(1759953599, 'DateTime')) GROUP BY dim0 ORDER BY visitors DESC, dim0 ASC LIMIT _CAST(0, 'Int64'), _CAST(9, 'Int64'). (UNKNOWN_IDENTIFIER) (version 25.8.2.29 (official build))
plausible-1  | 
plausible-1  |         (ecto_sql 3.12.1) lib/ecto/adapters/sql.ex:1096: Ecto.Adapters.SQL.raise_sql_call_error/1
plausible-1  |         (ecto_ch 0.6.0) lib/ecto/adapters/clickhouse.ex:323: Ecto.Adapters.ClickHouse.execute/5
plausible-1  |         (ecto 3.12.5) lib/ecto/repo/queryable.ex:232: Ecto.Repo.Queryable.execute/4
plausible-1  |         (ecto 3.12.5) lib/ecto/repo/queryable.ex:19: Ecto.Repo.Queryable.all/3
plausible-1  |         (plausible 0.0.1) lib/plausible/stats/query_runner.ex:48: Plausible.Stats.QueryRunner.execute_main_query/1
plausible-1  |         (plausible 0.0.1) lib/plausible/stats/query_runner.ex:40: Plausible.Stats.QueryRunner.run/2
plausible-1  |         (plausible 0.0.1) lib/plausible/stats/breakdown.ex:40: Plausible.Stats.Breakdown.breakdown/5
plausible-1  |         (plausible 0.0.1) lib/plausible_web/controllers/api/stats_controller.ex:481: PlausibleWeb.Api.StatsController.sources/2
```

Searching I came across [Github discussion #5794](https://github.com/plausible/analytics/discussions/5794#discussioncomment-14646542), which pointed me in the correct direction - apparently there's a [migration script](https://github.com/plausible/analytics/blob/master/rel/overlays/migrate.sh) being run when Plausible starts and this interferes with the other upgrades.

Solution:

* stopping Plausible completely
* temporarily removing the `&& /entrypoint.sh db migrate` part from the `command` line in `compose.yaml`{: .filepath }
* copying back the old pre-upgraded Clickhouse database
* starting Plausible (and ignoring any errors)
* executing the data migration for v2 (see above)
* shutting down Plausible
* restoring the `command` line in `compose.yaml`{: .filepath }
* starting up Plausible again

At this point Plausible did the secondary migration and everything started up without errors.
