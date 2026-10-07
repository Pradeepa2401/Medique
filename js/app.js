const departmentDoctors = {
  "Cardiology":["Dr. Ananya","Dr. Arjun","Dr. Meera"],
  "General Medicine":["Dr. Rahul","Dr. Priya","Dr. Vivek"],
  "Orthopedics":["Dr. Kumar","Dr. Neha","Dr. Suresh"],
  "Neurology":["Dr. Kavya","Dr. Rohan"],
  "Pediatrics":["Dr. Divya","Dr. Nikhil"],
  "Dermatology":["Dr. Isha","Dr. Varun"],
  "ENT":["Dr. Sneha","Dr. Ajay"],
  "Ophthalmology":["Dr. Anjali","Dr. Karthik"],
  "Gynecology":["Dr. Pooja","Dr. Nandini"],
  "Pulmonology":["Dr. Harish","Dr. Asha"]
};

const departments = Object.keys(departmentDoctors);

function $(id){return document.getElementById(id);}

async function getJSON(url, options){
  const r = await fetch(url, options);
  if(!r.ok) throw new Error("Server returned "+r.status);
  return r.json();
}

function setupDepartments(){
  const d=$("department"), doc=$("doctor");
  if(!d || !doc) return;
  d.innerHTML='<option value="">Select department</option>'+departments.map(x=>`<option value="${x}">${x}</option>`).join("");
  d.addEventListener("change",()=>{
    const list=departmentDoctors[d.value]||[];
    doc.innerHTML=list.length?'<option value="">Select doctor</option>'+list.map(x=>`<option value="${x}">${x}</option>`).join(""):'<option value="">Select department first</option>';
  });
}

async function submitToken(e){
  e.preventDefault();
  const msg=$("tokenMessage");
  const data=new URLSearchParams();
  data.set("action","token");
  data.set("patient","patient");
  data.set("name",$("pName").value);
  data.set("age",$("pAge").value);
  data.set("phone",$("pPhone").value);
  data.set("gender",$("pGender").value);
  data.set("address",$("pAddress").value);
  data.set("department",$("department").value);
  data.set("doctor",$("doctor").value);
  try{
    const r=await getJSON("api",{method:"POST",headers:{"Content-Type":"application/x-www-form-urlencoded"},body:data.toString()});
    sessionStorage.setItem("myToken",r.token);
    $("myToken").textContent=r.token;
    msg.textContent=`Token #${r.token} generated successfully. Please follow the live queue.`;
    msg.style.color="#86efac";
    loadQueue();
  }catch(err){msg.textContent="Unable to generate token. Please try again.";msg.style.color="#fca5a5";}
}

async function loadQueue(){
  try{
    const d=await getJSON("api?action=queue");
    if($("currentToken")) $("currentToken").textContent=d.currentToken||"—";
    if($("doctorCurrent")) $("doctorCurrent").textContent=d.currentToken||"—";
    if($("adminCurrent")) $("adminCurrent").textContent=d.currentToken||"—";
    if($("doctorStatCurrent")) $("doctorStatCurrent").textContent=d.currentToken||"—";
    if($("adminWaiting")) $("adminWaiting").textContent=d.waitingCount ?? d.waiting ?? 0;
    if($("doctorStatWaiting")) $("doctorStatWaiting").textContent=d.waitingCount ?? d.waiting ?? 0;
    const tokens=d.tokens||[];
    if($("doctorStatTotal")) $("doctorStatTotal").textContent=tokens.length;
    if($("adminTotal")) $("adminTotal").textContent=tokens.length;
    renderPatientQueue(tokens,d.currentToken);
    renderDoctorQueue(tokens,d.currentToken);
    renderAdminQueue(tokens,d.currentToken);
    const my=Number(sessionStorage.getItem("myToken")||0);
    if(my){
      const waiting=tokens.filter(x=>x.status==="WAITING");
      const idx=waiting.findIndex(x=>Number(x.token)===my);
      const ahead=idx<0?0:idx;
      if($("ahead")) $("ahead").textContent=ahead;
      if($("waitTime")) $("waitTime").textContent=ahead?`${ahead*10} min`:"Now";
      if($("patientNotice")){
        if(Number(d.currentToken)===my) $("patientNotice").textContent="🏥 IT'S YOUR TURN! Please proceed to the consultation room.";
        else if(ahead===1) $("patientNotice").textContent="🔔 NEXT PATIENT: YOU! Please get ready.";
        else if(idx>=0) $("patientNotice").textContent=`You are in the queue with ${ahead} patient(s) ahead.`;
        else $("patientNotice").textContent="Your token is not currently waiting.";
      }
    }
  }catch(e){}
}

function renderPatientQueue(tokens,current){
  const el=$("queueList"); if(!el)return;
  const waiting=tokens.filter(x=>x.status==="WAITING"||x.status==="CALLED");
  el.innerHTML=waiting.length?waiting.map(p=>`<div class="queue-item-app"><div><span class="token-num">#${p.token}</span><small>${p.name||"Patient"} · ${p.department||"Department"} · ${p.doctor||"Doctor"}</small></div><span class="waiting">${Number(p.token)===Number(current)?"NOW SERVING":p.status}</span></div>`).join(""):"<div class='notice'>No patients in the queue.</div>";
}

function renderDoctorQueue(tokens,current){
  const el=$("doctorQueue"); if(!el)return;
  el.innerHTML=tokens.length?tokens.map(p=>`<div class="queue-item-app"><div><span class="token-num">#${p.token}</span><small>${p.name||"Patient"} · ${p.age||"-"} yrs · ${p.department||"-"} · ${p.doctor||"-"}</small></div><span class="waiting">${p.status}</span></div>`).join(""):"<div class='notice'>No registered patients.</div>";
  const p=tokens.find(x=>Number(x.token)===Number(current));
  if($("doctorPatientName")) $("doctorPatientName").textContent=p?`${p.name||"Patient"} · Token #${p.token}`:"No patient called";
  if($("doctorPatientDetails")) $("doctorPatientDetails").textContent=p?`${p.age||"-"} years · ${p.gender||"-"} · ${p.phone||"-"} · ${p.department||"-"} · ${p.doctor||"-"}`:"Call the next patient to begin.";
}

function renderAdminQueue(tokens,current){
  const el=$("adminQueue"); if(!el)return;
  const active=tokens.filter(p=>p.status!=="COMPLETED");
  el.innerHTML=active.length?active.map(p=>`<div class="queue-item-app"><div><span class="token-num">#${p.token}</span><small>${p.name||"Patient"} · ${p.department||"-"} · ${p.doctor||"-"}</small></div><span class="waiting">${Number(p.token)===Number(current)?"CURRENT":p.status}</span></div>`).join(""):"<div class='notice'>No active patients.</div>";
}

async function callNext(){
  try{
    const d=await getJSON("api",{method:"POST",headers:{"Content-Type":"application/x-www-form-urlencoded"},body:"action=next"});
    if($("doctorMsg")) $("doctorMsg").textContent=d.message||"Next patient called.";
    loadQueue();
  }catch(e){if($("doctorMsg")) $("doctorMsg").textContent="Unable to call next patient.";}
}

async function completePatient(){
  try{
    const d=await getJSON("api",{method:"POST",headers:{"Content-Type":"application/x-www-form-urlencoded"},body:"action=complete"});
    if($("doctorMsg")) $("doctorMsg").textContent=d.message||"Consultation completed.";
    loadQueue();
  }catch(e){if($("doctorMsg")) $("doctorMsg").textContent="Unable to complete consultation.";}
}

async function sendHelp(){
  const input=$("helpMessage"), out=$("helpResult");
  if(!input||!input.value.trim()) return;
  const data=new URLSearchParams({action:"help",message:input.value.trim()});
  try{
    const d=await getJSON("api",{method:"POST",headers:{"Content-Type":"application/x-www-form-urlencoded"},body:data.toString()});
    if(out) out.textContent=d.message||"Help request sent.";
    input.value="";
  }catch(e){if(out) out.textContent="Unable to send request.";}
}

async function loadHelp(){
  const el=$("helpRequests"); if(!el)return;
  try{
    const d=await getJSON("api?action=help");
    const items=d.items||[];
    el.innerHTML=items.length?items.map(x=>`<div class="help-item"><b>Patient request</b>${x.message}<br><small>${x.reply||""}</small></div>`).join(""):"<div class='notice'>No requests yet.</div>";
  }catch(e){el.textContent="Unable to load requests.";}
}

async function loadAdmin(){
  await loadQueue();
  if($("adminDepartments")) $("adminDepartments").textContent=departments.length;
  if($("departmentList")) $("departmentList").innerHTML=departments.map(d=>`<div class="department"><span>🏥</span>${d}<b>${departmentDoctors[d].length} doctors</b></div>`).join("");
  const tbody=$("patientTable"); if(!tbody)return;
  try{
    const d=await getJSON("api?action=patients");
    const p=d.patients||[];
    tbody.innerHTML=p.length?p.map(x=>`<tr><td>#${x.token}</td><td>${x.name||"—"}</td><td>${x.age||"—"}</td><td>${x.phone||"—"}</td><td>${x.department||"—"}</td><td>${x.doctor||"—"}</td><td>${x.status||"—"}</td></tr>`).join(""):"<tr><td colspan='7'>No patients registered yet.</td></tr>";
  }catch(e){tbody.innerHTML="<tr><td colspan='7'>Unable to load patient database.</td></tr>";}
}

document.addEventListener("DOMContentLoaded",()=>{
  setupDepartments();
  const form=$("tokenForm"); if(form) form.addEventListener("submit",submitToken);
  loadQueue();
  if($("helpRequests")) loadHelp();
  if($("adminDepartments")) loadAdmin();
  setInterval(loadQueue,3000);
  if($("helpRequests")) setInterval(loadHelp,5000);
  if($("adminDepartments")) setInterval(loadAdmin,5000);
});
