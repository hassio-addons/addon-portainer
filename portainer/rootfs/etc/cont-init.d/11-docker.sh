#!/usr/bin/with-contenv bash
# ==============================================================================
# Community Hass.io Add-ons: Portainer
# Unprotects this add-on in order to gain access to the Docker socket
# ==============================================================================
# shellcheck disable=SC1091
source /usr/lib/hassio-addons/base.sh

readonly ENABLER="a0d7b954_docker-enabler"
declare slug
declare protected
declare installed

# Break in case the API is unreachable
if ! hass.api.supervisor.ping; then
    hass.die "Could you contact the HassIO API"
fi

# Get some info we would need.
slug=$(hass.addon.slug)
protected=$(hass.api.addons.info "${slug}" ".protected")

# Docker support is enabled!
if [[ -S "/var/run/docker.sock" ]]; then
    hass.log.info 'Docker support has been enabled.'
    exit "${EX_OK}"
fi

# Addon is already unprotected, awesome!
if hass.false "${protected}"; then
    exit "${EX_OK}"
fi

hass.log.info "Enabling Docker access..."

# Check if enabler is installed
installed=$(hass.api.addons.info.version "${ENABLER}")
if [[ "${installed}" = "null" ]]; then
    hass.api.addons.install "${ENABLER}"
fi

# Modify enabler options
if ! curl --silent --show-error \
    --request "POST" \
    -H "X-HASSIO-KEY: ${HASSIO_TOKEN}" \
    -d "{ \"options\": { \"target\": \"${slug}\" } }" \
    "${HASS_API_ENDPOINT}/addons/${ENABLER}/options";
then
    hass.die "Something went wrong contacting the API"
fi

# Run Enabler
hass.api.addons.start "${ENABLER}"

# Wait loop until option is enabled
hass.log.info "Process started, waiting until it succeeds..."
while hass.true "${protected}"; do
    sleep 1
    protected=$(hass.api.addons.info "${slug}" ".protected")
done

# Uninstall Enabler in case it was installed
if [[ "${installed}" = "null" ]]; then
    hass.api.addons.uninstall "${ENABLER}"
fi

# Self-restart
hass.log.info "Self-restart to activate Docker support."
hass.addon.restart
