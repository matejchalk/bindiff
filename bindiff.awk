function ishex(str)
{
    return match(str, /^[[:xdigit:]]{2}$/);
}

function diffNOToldascii(line, oldhex, x)
{
    oh = index(line, oldhex);
    return x == "|" && index(substr(line, oh, index(line, x) - oh), "\t");
}

function formatascii(ascii)
{
    return length(ascii) == 1 ? ascii : ".";
}

function join(array, start, end, key, delim,     res, i)
{
    res = array[start][key];
    for (i = start + 1; i <= end; i++)
        res = res delim array[i][key];
    return res;
}

function offset(off)
{
    return sprintf("%08x  ", off);
}

function spaces(n,      res, i)
{
    res = "";
    for (i = 0; i < n; i++)
        res = res " ";
    return res;
}

function hexspaces(hexes)
{
    return spaces(hexmaxlen - length(hexes));
}

function asciispaces(asciis)
{
    return spaces(asciimaxlen - length(asciis));
}

function black(str) {
    return "\033[1;30m" str "\033[0;0m";
}
function blue(str) {
    return "\033[1;34m" str "\033[0;0m";
}
function cyan(str) {
    return "\033[1;36m" str "\033[0;0m";
}
function green(str) {
    return "\033[1;32m" str "\033[0;0m";
}
function magenta(str) {
    return "\033[1;35m" str "\033[0;0m";
}
function red(str) {
    return "\033[1;31m" str "\033[0;0m";
}
function white(str) {
    return "\033[1;37m" str "\033[0;0m";
}
function yellow(str) {
    return "\033[1;33m" str "\033[0;0m";
}
function darkblack(str) {
    return "\033[0;30m" str "\033[0;0m";
}
function darkblue(str) {
    return "\033[0;34m" str "\033[0;0m";
}
function darkcyan(str) {
    return "\033[0;36m" str "\033[0;0m";
}
function darkgreen(str) {
    return "\033[0;32m" str "\033[0;0m";
}
function darkmagenta(str) {
    return "\033[0;35m" str "\033[0;0m";
}
function darkred(str) {
    return "\033[0;31m" str "\033[0;0m";
}
function darkwhite(str) {
    return "\033[0;37m" str "\033[0;0m";
}
function darkyellow(str) {
    return "\033[0;33m" str "\033[0;0m";
}

function colorsame(str)
{
    return black(str);
}

function colorchange(str)
{
    return darkgreen(str);
}

function colorold(str)
{
    return darkred(str);
}

function colornew(str)
{
    return darkblue(str);
}

function printdiff()
{
    pidx = 1;

    switch (lastdiff) {

    case "same or change":
        #print "oldhex: " join(difflines, 1, idx - 1, "oldhex", " ");
        #print "oldasc: " join(difflines, 1, idx - 1, "oldascii", "");
        #print "newhex: " join(difflines, 1, idx - 1, "newhex", " ");
        #print "newasc: " join(difflines, 1, idx - 1, "newascii", "");
        offsetsmatch = (oldoffset == newoffset);
        for (i = 1; i < idx; i++) {
            if (i % bunchsize == 0) {
                allbunchsame = 1;
                for (j = pidx; j <= i; j++) {
                    if (difflines[j]["oldhex"] == difflines[j]["newhex"]) {
                        difflines[j]["oldhex"] = colorsame(difflines[j]["oldhex"]);
                        difflines[j]["newhex"] = colorsame(difflines[j]["newhex"]);
                        difflines[j]["oldascii"] = colorsame(difflines[j]["oldascii"]);
                        difflines[j]["newascii"] = colorsame(difflines[j]["newascii"]);
                    } else {
                        allbunchsame = 0;
                        difflines[j]["oldhex"] = colorchange(difflines[j]["oldhex"]);
                        difflines[j]["newhex"] = colorchange(difflines[j]["newhex"]);
                        difflines[j]["oldascii"] = colorchange(difflines[j]["oldascii"]);
                        difflines[j]["newascii"] = colorchange(difflines[j]["newascii"]);
                    }
                }
                oldhexes = join(difflines, pidx, i, "oldhex", " ");
                oldasciis = join(difflines, pidx, i, "oldascii", "");
                newhexes = join(difflines, pidx, i, "newhex", " ");
                newasciis = join(difflines, pidx, i, "newascii", "");
                sep = allbunchsame ? colorsame(sepsame) : colorchange(sepchange);
                oldoff = offset(oldoffset - (idx - 1) + i - bunchsize);
                newoff = offset(newoffset - (idx - 1) + i - bunchsize);
                if (offsetsmatch) {
                    oldoff = colorsame(oldoff);
                    newoff = colorsame(newoff);
                } else {
                    oldoff = colorchange(oldoff);
                    newoff = colorchange(newoff);
                }
                print oldoff oldhexes cshasep oldasciis sep newoff newhexes cshasep newasciis;
                pidx = i + 1;
            }
        }
        if (--i % bunchsize == 0)
            return;
        allbunchsame = 1;
        for (j = pidx; j <= i; j++) {
            nocolor[j]["hex"] = difflines[j]["oldhex"];
            nocolor[j]["ascii"] = difflines[j]["oldascii"];
            if (difflines[j]["oldhex"] == difflines[j]["newhex"]) {
                difflines[j]["oldhex"] = colorsame(difflines[j]["oldhex"]);
                difflines[j]["newhex"] = colorsame(difflines[j]["newhex"]);
                difflines[j]["oldascii"] = colorsame(difflines[j]["oldascii"]);
                difflines[j]["newascii"] = colorsame(difflines[j]["newascii"]);
            } else {
                allbunchsame = 0;
                difflines[j]["oldhex"] = colorchange(difflines[j]["oldhex"]);
                difflines[j]["newhex"] = colorchange(difflines[j]["newhex"]);
                difflines[j]["oldascii"] = colorchange(difflines[j]["oldascii"]);
                difflines[j]["newascii"] = colorchange(difflines[j]["newascii"]);
            }
        }
        oldhexes = join(difflines, pidx, i, "oldhex", " ");
        oldasciis = join(difflines, pidx, i, "oldascii", "");
        newhexes = join(difflines, pidx, i, "newhex", " ");
        newasciis = join(difflines, pidx, i, "newascii", "");
        sep = allbunchsame ? colorsame(sepsame) : colorchange(sepchange);
        hs = hexspaces(join(nocolor, pidx, i, "hex", " "));
        as = asciispaces(join(nocolor, pidx, i, "ascii", ""));
        oldoff = offset(oldoffset - (idx - 1) + i - (i % bunchsize));
        newoff = offset(newoffset - (idx - 1) + i - (i % bunchsize));
        if (offsetsmatch) {
            oldoff = colorsame(oldoff);
            newoff = colorsame(newoff);
        } else {
            oldoff = colorchange(oldoff);
            newoff = colorchange(newoff);
        }
        print oldoff oldhexes hs cshasep oldasciis as sep newoff newhexes hs cshasep newasciis as;
        break;

    case "extra old":
        #print "oldhex: " join(difflines, 1, idx - 1, "oldhex", " ");
        #print "oldasc: " join(difflines, 1, idx - 1, "oldascii", "");
        for (i = 1; i < idx; i++) {
            if (i % bunchsize == 0) {
                oldhexes = join(difflines, pidx, i, "oldhex", " ");
                oldasciis = join(difflines, pidx, i, "oldascii", "");
                oldoff = offset(oldoffset - (idx - 1) + i - bunchsize);
                print colorold(oldoff oldhexes hasep oldasciis sepold);
                pidx = i + 1;
            }
        }
        if (--i % bunchsize == 0)
            return;
        oldhexes = join(difflines, pidx, i, "oldhex", " ");
        oldasciis = join(difflines, pidx, i, "oldascii", "");
        hs = hexspaces(oldhexes);
        as = asciispaces(oldasciis);
        oldoff = offset(oldoffset - (idx - 1) + i - (i % bunchsize));
        print colorold(oldoff oldhexes hs hasep oldasciis as sepold);
        break;

    case "extra new":
        #print "newhex: " join(difflines, 1, idx - 1, "newhex", " ");
        #print "newasc: " join(difflines, 1, idx - 1, "newascii", "");
        for (i = 1; i < idx; i++) {
            if (i % bunchsize == 0) {
                newhexes = join(difflines, pidx, i, "newhex", " ");
                newasciis = join(difflines, pidx, i, "newascii", "");
                newoff = offset(newoffset - (idx - 1) + i - bunchsize);
                print colornew(sepnew newoff newhexes hasep newasciis as);
                pidx = i + 1;
            }
        }
        if (--i % bunchsize == 0)
            return;
        newhexes = join(difflines, pidx, i, "newhex", " ");
        newasciis = join(difflines, pidx, i, "newascii", "");
        hs = hexspaces(newhexes);
        as = asciispaces(newasciis);
        newoff = offset(newoffset - (idx - 1) + i - (i % bunchsize));
        print colornew(sepnew newoff newhexes hs hasep newasciis as);
        break;
    }
}

BEGIN {
    if (!bunchsize)
        bunchsize = 8;
    if (hexasciisep) {
        hasep = " " hexasciisep " ";
    } else {
        hasep = " | ";
    }
    cshasep = colorsame(hasep);
    sepsame =   "\t\t\t\t  ";
    sepchange = "\t\t\t\t| ";
    sepold =    "\t\t\t\t<" ;
    sepnew =    "\t\t\t\t> ";
    hexmaxlen = bunchsize * 2 + bunchsize - 1;
    asciimaxlen = bunchsize;
    sepnew = spaces(length(offset(0)) + hexmaxlen + length(hasep) + asciimaxlen) sepnew;
    oldoffset = 0;
    newoffset = 0;
    lastdiff = "X";
}

{
    oldhex = "";
    oldascii = "";
    diff = "";
    newhex = "";
    newascii = "";

    switch (NF) {
    case 5:
        oldhex = $1;
        oldascii = $2;
        diff = $3;
        newhex = $4;
        newascii = $5;
        break;
    case 4:
        oldhex = $1;
        if (ishex($4)) {
            oldascii = $2;
            diff = $3;
            newhex = $4;
        } else {
            newhex = $3;
            newascii = $4;
            if (diffNOToldascii($0, oldhex, $2)) {
                diff = $2;
            } else {
                oldascii = $2;
            }
        }
        break;
    case 3:
        if ($1 == ">") {
            diff = $1;
            newhex = $2;
            newascii = $3;
        } else {
            oldhex = $1;
            if (ishex($3)) {
                newhex = $3;
                if (diffNOToldascii($0, oldhex, $2)) {
                    diff = $2;
                } else {
                    oldascii = $2;
                }
            } else if (ishex($2)) {
                newhex = $2;
                newascii = $3;
            } else {
                oldascii = $2;
                diff = $3; # error if not "<"
            }
        }
        break;
    case 2:
        if (ishex($1)) {
            oldhex = $1;
            if ($2 == "<") {
                diff = $2;
            } else {
                newhex = $2;
            }
        } else {
            diff = $1; # error if not ">"
            newhex = $2;
        }
        break;
    }
      
    oldascii = formatascii(oldascii);
    newascii = formatascii(newascii);
    
    switch (diff) {
    case "":
    case "|":
        diff = "same or change";
        break;
    case "<":
        diff = "extra old";
        break;
    case ">":
        diff = "extra new";
        break;
    }
    
    if (diff != lastdiff) {
        printdiff();
        for (x in difflines)
            delete difflines[x];
        idx = 1;
        lastdiff = diff;
    }

    switch (diff) {
    case "same or change":
        difflines[idx]["oldhex"] = oldhex;
        difflines[idx]["oldascii"] = oldascii;
        difflines[idx]["newhex"] = newhex;
        difflines[idx]["newascii"] = newascii;
        oldoffset++;
        newoffset++;
        break;
    case "extra old":
        difflines[idx]["oldhex"] = oldhex;
        difflines[idx]["oldascii"] = oldascii;
        oldoffset++;
        break;
    case "extra new":
        difflines[idx]["newhex"] = newhex;
        difflines[idx]["newascii"] = newascii;
        newoffset++;
        break;
    }
    
    idx++;
}

END {
    printdiff();
}
