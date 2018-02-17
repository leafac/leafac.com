#lang pollen

◊define-meta[title]{License}

◊margin-note{See the ◊link/internal["/software/www.leafac.com/"]{source code for the website}.}

◊new-thought{The license} for all written material in the website is ◊link["https://www.gnu.org/licenses/fdl.html"]{◊initialism{GNU FDL}}:

◊full-width{
 ◊code/block{
  Copyright (C) ◊(->string (->year (today))) ◊(dict-ref personal-data 'author).
  Permission is granted to copy, distribute and/or modify this document
  under the terms of the GNU Free Documentation License, Version 1.3
  or any later version published by the Free Software Foundation;
  with no Invariant Sections, no Front-Cover Texts, and no Back-Cover Texts.
  A copy of the license is included in the section entitled "GNU
  Free Documentation License".
 }
}

The license for all the code in the website is ◊link["https://www.gnu.org/licenses/gpl.html"]{◊initialism{GNU GPL}}:

◊full-width{
 ◊code/block{
  Copyright (C) ◊(->string (->year (today))) ◊(dict-ref personal-data 'author)
                
  This program is free software: you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation, either version 3 of the License, or
  (at your option) any later version.
  
  This program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.
  
  You should have received a copy of the GNU General Public License
  along with this program.  If not, see <http://www.gnu.org/licenses/>.
 }
}
