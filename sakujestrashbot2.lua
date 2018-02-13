local Twitter = require("twitter").Twitter
local json = require("rapidjson")

config = json.load("./config.sakujes")
math.randomseed(os.time())

local twitter =
    Twitter(
    {
        consumer_key = config["consumer_key"],
        consumer_secret = config["consumer_secret"],
        access_token = config["access_key"],
        access_token_secret = config["access_secret"]
    }
)

function getLine()
    local count = 0
    for _ in io.lines("./stuff.sakujes") do
        count = count + 1
    end
    random = math.random(count)
    iter = io.lines("./stuff.sakujes")
    for i = 0, random do
        if not iter() then
            error "file is empty or doesn't exist (?)"
        end
    end
    return iter()
end

function getStart()
    local count = 0
    for _ in pairs(config["words_start"]) do
        count = count + 1
    end
    return config["words_start"][math.random(count)]
end

function getEnd()
    local count = 0
    for _ in pairs(config["words_end"]) do
        count = count + 1
    end
    return config["words_end"][math.random(count)]
end

local clock = os.clock
function sleep(n)
  local t0 = clock()
  while clock() - t0 <= n do end
end

while true do
    local line = getStart() .. getLine():match("(.-)%s*$") .. getEnd()
    print("sending tweet:", line)
    twitter:post_status(
    {
        status = line
    })
    print("sent tweet:", line)
    sleep(900)
end
