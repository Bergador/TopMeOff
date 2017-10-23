local reagents = {{"Sacred Candle", 20},
				  {"Wild Thornroot", 20},
				  {"Ironwood Seed", 20},
				  {"Combat Mana Potion", 5},
				  {"Combat Healing Potion", 5},
				  {"Infernal Stone", 5},
				  {"Demonic Figure", 5},
				  {"Arcane Powder", 20},
				  {"Wild Berries", 20},
				  {"Holy Candle", 20},
				  {"Ankh", 5},
				  {"Rune of Teleportation", 10},
				  {"Rune of Portals", 10},
				  {"Symbol of Divinity", 5},
				  {"Maple Seed", 20},
				  {"Stranglethorn Seed", 20},
				  {"Ashwood Seed", 20},
				  {"Hornbeam Seed", 20},
				  {"Symbol of Kings", 100}}

function TopMeOff_OnLoad()		
	this:RegisterEvent("MERCHANT_SHOW");
end

function TopMeOff_OnEvent()
	if( event == "MERCHANT_SHOW" ) then
		BuyReagents();
	end
end

function BuyReagents()
	local shoppingList = {};
	
	for i = 1, table.getn(reagents) do
		-- shoppingList[i][2] = 0;
		table.insert(shoppingList, {reagents[i][1], 0})
	end

	for bagID = 0, 4 do
		for slot = 1, GetContainerNumSlots(bagID) do
			local itemName, itemCount = GetBagItemNameAndCount(bagID, slot);
			
			if itemName ~= nil and itemCount ~= nil then
				for r = 1, table.getn(reagents) do
					if itemName == reagents[r][1] then
						--DEFAULT_CHAT_FRAME:AddMessage(itemCount.."/"..reagents[r][2].." "..reagents[r][1].."\" found at ("..bagID..","..slot..")");
						
						shoppingList[r][2] = shoppingList[r][2] + reagents[r][2]-itemCount
					end
				end
			end
		end
	end
	
	local messageDisplayed = false;
	
	for index = 0, GetMerchantNumItems() do
		local name, texture, price, quantity = GetMerchantItemInfo(index)
		
		for r = 1, table.getn(shoppingList) do
			
			local thisMany = math.floor(shoppingList[r][2]/quantity);  -- to make if Symbol of Kings friendly
																				  -- just for you, Rtm <3
		
			if name == shoppingList[r][1] and thisMany > 0 then
				if not messageDisplayed then
					-- DEFAULT_CHAT_FRAME:AddMessage("[TopMeOff] Topping you off on reagents.");
					DEFAULT_CHAT_FRAME:AddMessage("|cffffff00<TopMeOff> Topping you off on reagents.|r");
					messageDisplayed = true;
				end
				BuyMerchantItem(index, thisMany)
			end
		end
	end	
end

function GetBagItemNameAndCount(bag, item)
	for i = 1, 29, 1 do
		getglobal("TopMeOffTooltipTextLeft" .. i):SetText("");
	end

	TopMeOffTooltip:SetBagItem(bag, item);
	
	local text = getglobal("TopMeOffTooltipTextLeft1")
	
	local _, itemCount = GetContainerItemInfo(bag, item);
	
	if text ~= nil then
		return text:GetText(), itemCount;
	else
		return "", itemCount;
	end
end
