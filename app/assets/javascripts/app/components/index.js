import focusTrapProxy from './focus-trap-proxy';
import modal from './modal';
import Accordion from './accordion';

window.LoginGov = (window.LoginGov || {});
const LoginGov = window.LoginGov;
const trapModal = modal(focusTrapProxy);

LoginGov.Modal = trapModal;

document.addEventListener('DOMContentLoaded', () => {
  const elements = document.querySelectorAll('.accordion');

  LoginGov.accordions = [].slice.call(elements).map((element) => {
    const accordion = new Accordion(element);
    accordion.setup();

    return accordion;
  });

  const backButtons = document.querySelectorAll('.back-button');

  backButtons.forEach(function(button) {
    button.addEventListener('click', function() {
      history.back(-1);
    });
  });
});

export {
  trapModal as Modal,
};
