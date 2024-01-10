
class FilterModule(object):
    """Domain name filters class"""
    def filters(self):
        """Map filter name to function."""
        return {
            'toplevel_domain_name': self.toplevel_domain,
            'domain_name': self.domain
        }

    def toplevel_domain(self, fqdn):
        """Return the top-level domain name of the
        fully qualified domain name fqdn.
        """
        return '.' + fqdn.split('.')[-1]

    def domain(self, fqdn: str):
        """Return the domain name of the
        fully qualified domain name fqdn.
        """
        parts = fqdn.split('.')[-2:]
        return '.'.join(parts)
