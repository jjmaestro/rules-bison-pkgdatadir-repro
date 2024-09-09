# Copyright 2024 EngFlow Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License"); you may not
# use this file except in compliance with the License. You may obtain a copy of
# the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
# License for the specific language governing permissions and limitations under
# the License.

"""Macros and rules for accessing canonical repository names and paths"""

# These rules will produce the repo name of the target of an `alias` rule,
# defined by its `actual` attribute.

def _variable_info(ctx, value):
    """Return a TemplateVariableInfo provider for Make variable rules."""
    return [platform_common.TemplateVariableInfo({ctx.attr.name: value})]

repo_name_variable = rule(
    implementation = lambda ctx: _variable_info(
        ctx, ctx.attr.dep.label.repo_name
    ),
    doc = "Defines a custom variable for its dependency's repository name",
    attrs = {
        "dep": attr.label(
            mandatory = True,
            doc = "target for which to extract the repository name",
        ),
    },
)
