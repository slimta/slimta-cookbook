slimta Cookbook
===============
Install and configure slimta on a system using Chef.

Requirements
------------

<!--
#### packages
- `toaster` - slimta needs toaster to brown your bagel.
-->

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
  <!--<tr>
    <td><tt>['slimta']['bacon']</tt></td>
    <td>Boolean</td>
    <td>whether to include bacon</td>
    <td><tt>true</tt></td>
  </tr>-->
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

