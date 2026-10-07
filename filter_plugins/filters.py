"""
This file defines an Ansible filter that shortens hostnames.
"""
class FilterModule:
    """Filter class"""
    def filters(self):
        """Map filter names to functions."""
        return {
            'hostname_short': self.hostname_short
        }

    def hostname_short(self, fqdn):
        """Return the first part of the
        fully qualified domain name (fqdn).
        """
        if not isinstance(fqdn, str) or not fqdn or "." not in fqdn:
            raise ValueError(
                "fqdn must be a non-empty string containing '.'"
            )
        return fqdn.split('.')[0]
