// Copyright (c) 2020 /vg/station coders
// SPDX-License-Identifier: MIT

import { useBackend } from '../backend';
import { Button, LabeledList, Section, Flex, Modal, Icon } from '../components';
import { Window } from '../layouts';
import { ButtonCheckbox } from '../components/Button';

export const StripButton = (props, context) => {
  return (
    <Button
      disabled={props.obscured}
      onClick={() => act("strip", { "kind": props.kind, "slotID": props.slotID })}>
      {text}
    </Button>);
};

export const Inventory = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    title,
    hands,
    slots,
    pockets,
    handcuffs,
    legcuffs,
  } = data;
  return (
    <Window
      title={title}
      width={400}
      height={500}>
      <Window.Content>
        {hands && (
          <Section
            title="Hands">
            <LabeledList>
              {hands.map(hand => (
                <LabeledList.Item
                  key={hand.handName}
                  label={hand.handName}>
                  <StripButton
                    kind="hand"
                    slotID={hand.handIndex}
                    text={hand.itemName} />
                </LabeledList.Item>
              ))}
            </LabeledList>
          </Section>)}
        {slots && (
          <Section
            title="Inventory">
            <LabeledList>
              {slots.map(slot => (
                <LabeledList.Item
                  key={slot.slotName}
                  label={slot.slotName}>
                  <StripButton
                    kind="slot"
                    slotID={slot.slotID}
                    text={hand.itemName} />
                </LabeledList.Item>
              ))}
            </LabeledList>
          </Section>)}
        {pockets && (
          <Section
            title="Pockets">
            <LabeledList>
              {pockets.map(pocket => (
                <LabeledList.Item
                  key={pocket.pocketName}
                  label={pocket.pocketName}>
                  <StripButton
                    kind="pocket"
                    slotID={pocket.pocketName}
                    text={pocket.itemName} />
                </LabeledList.Item>
              ))}
            </LabeledList>
          </Section>)}
        {cuffs && (
          <Section
            title="Cuffs">
            <LabeledList>
              {cuffs.map(cuff => (
                <LabeledList.Item
                  key={cuff.slotName}
                  label={cuff.slotName}>
                  <StripButton
                    kind="slot"
                    slotID={cuff.slotName}
                    text={cuff.itemName} />
                </LabeledList.Item>
              ))}
            </LabeledList>
          </Section>)}
      </Window.Content>
    </Window>
  );
};
