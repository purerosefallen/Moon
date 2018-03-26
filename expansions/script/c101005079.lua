--単一化
--Standardization
--Scripted by Eerie Code
function c101005079.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCondition(c101005079.condition)
	e1:SetTarget(c101005079.target)
	e1:SetOperation(c101005079.activate)
	c:RegisterEffect(e1)
end
function c101005079.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()~=PHASE_DAMAGE or not Duel.IsDamageCalculated()
end
function c101005079.filter(c,tp)
	return c:IsFaceup() and Duel.IsExistingMatchingCard(c101005079.filter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,c,c:GetAttack())
end
function c101005079.filter2(c,atk)
	return c:IsFaceup() and c:GetAttack()~=atk
end
function c101005079.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c101005079.filter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c101005079.filter,tp,0,LOCATION_MZONE,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c101005079.filter,tp,0,LOCATION_MZONE,1,1,nil,tp)
end
function c101005079.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or tc:IsFacedown() then return end
	local atk=tc:GetAttack()
	local g=Duel.GetMatchingGroup(c101005079.filter2,tp,LOCATION_MZONE,LOCATION_MZONE,tc,atk)
	for sc in aux.Next(g) do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(atk)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		sc:RegisterEffect(e1)
	end
end