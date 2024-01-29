
class FilterModule(object):
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
        return fqdn.split('.')[0]
