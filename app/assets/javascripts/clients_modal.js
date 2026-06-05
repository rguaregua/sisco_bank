(() => {
  if (window.clientModalListenersBound) return;
  window.clientModalListenersBound = true;

  const fields = [
    ["id", "ID"],
    ["type_of_person", "Tipo persona"],
    ["type_of_document", "Tipo documento"],
    ["document_number", "Numero documento"],
    ["document_issued_at", "Fecha emision"],
    ["document_expires_at", "Fecha vencimiento"],
    ["email", "Correo"],
    ["primary_phone", "Telefono principal"],
    ["secondary_phone", "Telefono secundario"],
    ["created_at", "Creado"]
  ];

  const renderRows = (content, payload) => {
    content.innerHTML = fields.map(([key, label]) => {
      const rawValue = payload[key];
      const value = rawValue && String(rawValue).trim() ? String(rawValue) : "-";

      return `
        <div class="rounded-xl border border-slate-200 bg-slate-50 px-3 py-2">
          <strong class="text-slate-900">${label}:</strong> ${value}
        </div>
      `;
    }).join("");
  };

  const openClientModal = (trigger) => {
    const modal = document.getElementById("client-modal");
    const content = document.getElementById("client-modal-content");
    const subtitle = document.getElementById("client-modal-subtitle");
    const editLink = document.getElementById("modal-client-edit-link");

    if (!modal || !content || !subtitle || !editLink) return;
    if (typeof modal.showModal !== "function") return;

    const payloadText = trigger.dataset.clientModalPayload;
    if (!payloadText) return;

    let payload;
    try {
      payload = JSON.parse(payloadText);
    } catch (_error) {
      return;
    }

    subtitle.textContent = payload.full_name || "Detalle del cliente";
    renderRows(content, payload);

    editLink.href = payload.edit_path || "#";

    modal.showModal();
  };

  document.addEventListener("click", (event) => {
    const trigger = event.target.closest("[data-client-modal-trigger='true']");
    if (!trigger) return;

    event.preventDefault();
    openClientModal(trigger);
  });

  document.addEventListener("click", (event) => {
    const modal = document.getElementById("client-modal");
    if (!modal || !modal.open) return;
    if (event.target !== modal) return;

    const rect = modal.getBoundingClientRect();
    const clickedOutside =
      event.clientX < rect.left ||
      event.clientX > rect.right ||
      event.clientY < rect.top ||
      event.clientY > rect.bottom;

    if (clickedOutside) modal.close();
  });
})();
