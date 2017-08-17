slimta Cookbook
===============

Install and configure slimta on a system using Chef.

### _THIS COOKBOOK IS DEPRECATED_

Requirements
------------

#### cookbooks
- `python` - slimta uses the [python cookbook](https://github.com/poise/python)
  for installation.

Attributes
----------

#### slimta::default
<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['slimta']['virtualenv']</tt></td>
    <td>String</td>
    <td>Path where the virtualenv will be created.</td>
    <td><tt>/opt/slimta</tt></td>
  </tr>
  <tr>
    <td><tt>['slimta']['exclude']</tt></td>
    <td>Array</td>
    <td>These slimta packages will not be installed by pip.</td>
    <td><tt>[]</tt></td>
  </tr>
  <tr>
    <td><tt>['slimta']['version_lock']</tt></td>
    <td>Hash</td>
    <td>Maps slimta package names to the version they should be locked to.</td>
    <td><tt>{}</tt></td>
  </tr>
</table>

Usage
-----
#### slimta::default

Just include `slimta` in your node's `run_list`:

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[slimta]"
  ]
}
```

