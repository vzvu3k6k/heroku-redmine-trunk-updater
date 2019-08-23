# heroku-redmine-trunk-updater

A Redmine plugin for https://github.com/vzvu3k6k/heroku-redmine-trunk.

Receives pushes to <https://hub.docker.com/r/vzvu3k6k/redmine> via [Docker Hub webhooks](https://docs.docker.com/docker-hub/webhooks/) to update `Dockerfile` in [vzvu3k6k/heroku-redmine-trunk](https://github.com/vzvu3k6k/heroku-redmine-trunk).

## A Webhook Endpoint

`https://redmine-trunk-demo.herokuapp.com/update_webhook?token=foobar`

## Environment Variables

- `REDMINE_TRUNK_UPDATER_TOKEN` (required): Used to verify a webhook request. Add `?token={REDMINE_TRUNK_UPDATER_TOKEN}` to a webhook URL.
- `REDMINE_TRUNK_UPDATER_DEPLOY_KEY` (required): [A deploy key](https://developer.github.com/v3/guides/managing-deploy-keys/#deploy-keys) for [vzvu3k6k/heroku-redmine-trunk](https://github.com/vzvu3k6k/heroku-redmine-trunk)
