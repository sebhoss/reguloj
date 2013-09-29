/*
 * Copyright © 2010 Sebastian Hoß <mail@shoss.de>
 * This work is free. You can redistribute it and/or modify it under the
 * terms of the Do What The Fuck You Want To Public License, Version 2,
 * as published by Sam Hocevar. See http://www.wtfpl.net/ for more details.
 */
package com.github.sebhoss.reguloj;

import com.google.common.base.Predicate;

abstract class RulePredicate<CONTEXT extends Context<?>> implements Predicate<Rule<CONTEXT>> {

    protected final CONTEXT context;

    RulePredicate(final CONTEXT context) {
        this.context = context;
    }

}
