#!/usr/bin/with-contenv bashio
# ==============================================================================
# Home Assistant Community Add-on: Portainer
# Runs some initializations for Portainer
# ==============================================================================
bashio::require.unprotected

if bashio::config.has_value 'agentsecret' ; then
    bashio::log.info 'Setting the Agent Secret'
    export AGENT_SECRET=$(bashio::config 'agentsecret')
fi
