function envsource
    set -l target $argv[1]
    if test -z "$target"
        set target ".env"
    end

    if not test -f $target
        echo "Error: File '$target' not found."
        return 1
    end

    echo "Sourcing from $target..."

    # Skip comments and blank lines
    cat $target | grep -v '^\s*#' | grep -v '^\s*$' | while read -l line
        # Allow optional 'export ' prefix
        set line (string replace -r '^\s*export\s+' '' -- $line)

        # Split exactly once at the first '=' sign
        set -l item (string split -m 1 '=' -- $line)

        # Check if we actually got a key-value pair
        if test (count $item) -eq 2
            # Trim whitespace, then surrounding quotes
            set -l key (string trim -- $item[1])
            set -l value (string trim -- $item[2] | string trim -c '"\'')

            set -gx $key $value
        end
    end
end
